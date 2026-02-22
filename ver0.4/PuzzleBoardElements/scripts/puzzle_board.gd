extends Control

@onready var board_tiles = $GridContainer/Middle/BoardTiles
@onready var orb_container = %OrbContainer

var selected_orb : Orb
var turn_state := GlobalConstants.TURN_STATES.PLANNING

var board_width : int = 6
var board_height : int = 5
var all_tiles : Array[Node]

var orb_deletion_queue : Array[Orb]

func _ready():
	$Label.text = GlobalConstants.TURN_STATES.keys()[turn_state]
	
	SignalManager.state_changed.connect(_on_turn_state_change)
	SignalManager.orb_selected.connect(_on_orb_selected)
	SignalManager.orb_dropped.connect(_on_orb_dropped)
	SignalManager.orb_deleted.connect(wait_for_deletion_queue)
	
	# set up board
	all_tiles = board_tiles.get_children()
	for x in range(board_width):
		for y in range(board_height):
			var current_index = (y * board_width) + x
			
			var up_index = (y - 1) * board_width + x
			if up_index >= 0:
				all_tiles[current_index].up = all_tiles[up_index]
			
			var down_index = (y + 1) * board_width + x
			if down_index < board_width * board_height:
				all_tiles[current_index].down = all_tiles[down_index]
			
			var left_index = current_index - 1
			if left_index >= 0 and int(left_index / board_width) == int(current_index / board_width):
				all_tiles[current_index].left = all_tiles[left_index]
			
			var right_index = current_index + 1
			if right_index < board_width * board_height and int(right_index / board_width) == int(current_index / board_width):
				all_tiles[current_index].right = all_tiles[right_index]

func apply_skyfall():
	var reverse_board_tiles = all_tiles.duplicate()
	reverse_board_tiles.reverse()
	for tile in reverse_board_tiles:
		if tile.orb and tile.down and not tile.down.orb:
			var next_tile = tile.down
			while next_tile.down and not next_tile.down.orb:
				next_tile = next_tile.down
			next_tile.orb = tile.orb
			next_tile.orb.parent_tile = next_tile
			next_tile.orb.moveTo(next_tile.center_global_position)
			tile.orb = null

func check_orb_matches(base_tile : OrbTile):
	var base_orb = base_tile.orb
	var orb_type = base_orb.orb_type
	var match_array = [base_orb]

	# right
	var current_tile = base_tile
	var count_array = []
	while current_tile.right and current_tile.right.orb:
		current_tile = current_tile.right
		if current_tile.orb.orb_type == orb_type:
			count_array.append(current_tile.orb)
		else:
			break
	if count_array.size() > 1:
		match_array.append_array(count_array)
	
	# down
	current_tile = base_tile
	count_array = []
	while current_tile.down and current_tile.down.orb:
		current_tile = current_tile.down
		if current_tile.orb.orb_type == orb_type:
			count_array.append(current_tile.orb)
		else:
			break
	if count_array.size() > 1:
		match_array.append_array(count_array)
	
	if match_array.size() < 3:
		return []

	return match_array

func clearBoard():
	for tile in all_tiles:
		if tile.orb:
			orb_deletion_queue.append(tile.orb)
			tile.orb.queue_for_deletion()
			tile.orb = null

func flood_fill(parent_tile : OrbTile, array : Array, type : String) -> void:
	if not parent_tile or not parent_tile.orb or parent_tile.orb.resolved:
		return
	
	if parent_tile.orb.orb_type == type and parent_tile.orb in array:
		parent_tile.orb.resolved = true
		orb_deletion_queue.append(parent_tile.orb)
		flood_fill(parent_tile.up, array, type)
		flood_fill(parent_tile.left, array, type)
		flood_fill(parent_tile.down, array, type)
		flood_fill(parent_tile.right, array, type)

func resolve_board() -> Array:
	var current_orb : Orb
	var orb_matches : Array
	var resolved : Array
	var combos : Array
	
	while true:
		for tile in all_tiles:
			if tile.orb and tile.orb not in resolved:
				orb_matches = check_orb_matches(tile)
				
				if orb_matches.is_empty():
					continue
				
				for orb in orb_matches:
					if not resolved.has(orb):
						resolved.append(orb)
		
		if resolved.is_empty():
			break
		
		var resolved_sets = await resolve_orbs(resolved)
		
		combos.append(resolved_sets)
		
		apply_skyfall()
		
		resolved_sets.clear()
		resolved.clear()
	
	return combos

func resolve_orbs(to_resolve : Array):
	var final_combos = []
	
	# also should handle maybe special shape detection here
	# for now, combos are just type and size, maybe add that special shapes later
	
	for tile in all_tiles:
		if tile.orb and tile.orb in to_resolve and not tile.orb.resolved:
			flood_fill(tile, to_resolve, tile.orb.orb_type)
			final_combos.append([tile.orb.orb_type,orb_deletion_queue.size()])
			
			for orb in orb_deletion_queue:
				orb.queue_for_deletion()
				orb.parent_tile.orb = null
			
			await SignalManager.all_orbs_resolved
	
	return final_combos

func regenerate_board():
	SignalManager.generate_orbs.emit()

func wait_for_deletion_queue(orb : Orb):
	if orb in orb_deletion_queue:
		orb_deletion_queue.erase(orb)
	
	if orb_deletion_queue.is_empty():
		SignalManager.all_orbs_resolved.emit()

func _on_turn_state_change(state : GlobalConstants.TURN_STATES) -> void:
	turn_state = state
	$Label.text = GlobalConstants.TURN_STATES.keys()[state]

func _on_orb_selected(selected_orb : Orb):
	self.selected_orb = selected_orb

func _on_orb_dropped(_orb_dropped : Orb):
	selected_orb.orb_dropped()
	selected_orb = null

func _on_button_pressed():
	regenerate_board()
	
func _on_tile_resized():
	if is_instance_valid(board_tiles):
		SignalManager.orb_resized.emit(board_tiles.get_child(0).size.x)

func _on_gui_input(event):
	if event.is_action_released("click"):
		if selected_orb:
			match turn_state:
				GlobalConstants.TURN_STATES.EXECUTION:
					SignalManager.orb_dropped.emit(selected_orb)
					SignalManager.state_changed.emit(GlobalConstants.TURN_STATES.PLANNING)
				_:
					SignalManager.orb_dropped.emit(selected_orb)

func _on_button_2_pressed():
	resolve_board()
