extends Sprite2D

@onready var nodes = $Nodes
@onready var orbs = $Orbs
@onready var temp_orb_asset_paths = [preload("res://tempassets/yellowOrb.png"), 
									preload("res://tempassets/greenOrb.png"), 
									preload("res://tempassets/blueOrb.png"),
									preload("res://tempassets/pinkOrb.png"),
									preload("res://tempassets/redOrb.png")]
@onready var new_orb_scene = preload("res://orb.tscn")
@onready var turn_manager = $"../TurnManager"

var node_link : Dictionary = {}
var orb_link : Dictionary = {}
var turn_actions : Array[ActionInstance] = []

var target_orb : Orb

const ROWS = 5
const COLS = 6

func _ready():
	SignalManager.orb_swap.connect(orbSwap)
	SignalManager.orb_dropped.connect(orbDropped)
	
	for child in nodes.get_children():
		node_link[child.position] = child
	
	regenerateBoard()

func regenerateBoard():
	for node in nodes.get_children():
		if node.position not in orb_link:
			var rng = randi_range(0,4)
			var neworb = new_orb_scene.instantiate()
			neworb.newOrb(rng, temp_orb_asset_paths[rng], node.position)
			
			orb_link[node.position] = neworb
			orbs.add_child(neworb)

func resolveBoard():
	var current_orb : Orb
	var orb_matches : Array
	var resolved : Array
	var combos : Array
	
	while true:
		for node in nodes.get_children():
			if orb_link.has(node.position):
				current_orb = orb_link[node.position]
				orb_matches = checkOrbMatches(current_orb)
				for orb in orb_matches:
					if not resolved.has(orb):
						resolved.append(orb)
		
		if resolved.is_empty():
			break
		
		combos.append(resolveOrbs(resolved))
		
		for orb in resolved:
			if orb_link.has(orb.board_position):
				orb_link[orb.position].queue_free()
				orb_link.erase(orb.position)
		
		# let orbs drop
		var tempArray = nodes.get_children()
		tempArray.reverse()
		for nodes in tempArray:
			if orb_link.has(nodes.position):
				var orb = orb_link[nodes.position]
				var position_below_orb = orb.board_position + Vector2(0,100)
				if node_link.has(position_below_orb) and not orb_link.has(position_below_orb):
					while node_link.has(position_below_orb) and not orb_link.has(position_below_orb):
						position_below_orb = position_below_orb + Vector2(0,100)
					position_below_orb = position_below_orb - Vector2(0,100)
					orb_link.erase(orb.board_position)
					orb.moveTo(position_below_orb)
					orb_link[orb.board_position] = orb
		
		resolved = []
	
	turn_actions = []
	for action_list in combos:
		$"../../../DebugButtons/Label2".text += str(action_list) + "\n"
		var attack_actions = []
		var block_actions = []
		var heal_actions = []
		
		for action in action_list:
			var action_instance = ActionInstance.new()
			
			action_instance.orb_count = action[1]
			action_instance.actor = turn_manager.player
			match action[0]:
				"MELEE":
					action_instance.instance_type = ActionInstance.TYPE.MATTACK
					attack_actions.append(action_instance)
				"RANGED":
					action_instance.instance_type = ActionInstance.TYPE.RATTACK
					attack_actions.append(action_instance)
				"CHARGE":
					# just add to resource
					continue
				"BLOCK":
					action_instance.instance_type = ActionInstance.TYPE.BLOCK
					block_actions.append(action_instance)
				"HEAL":
					action_instance.instance_type = ActionInstance.TYPE.HEAL
					heal_actions.append(action_instance)

		turn_actions.append_array(attack_actions)
		turn_actions.append_array(block_actions)
		turn_actions.append_array(heal_actions)
	
	SignalManager.actions_populated.emit(turn_actions)
	
func clearBoard():
	for node in nodes.get_children():
		if orb_link.has(node.position):
			orb_link[node.position].queue_free()
			orb_link.erase(node.position)
	
func orbSwap(selectedOrb : Orb, orb : Orb):
	var temp_position = selectedOrb.board_position
	selectedOrb.board_position = orb.board_position
	orb.board_position = temp_position
	
	orb_link[selectedOrb.board_position] = selectedOrb
	orb_link[orb.board_position] = orb
	selectedOrb.moveTo(selectedOrb.board_position)
	orb.moveTo(orb.board_position)


func orbDropped(orb : Orb):
	orb.moveTo(orb.board_position)
	
func checkOrbMatches(orb : Orb):
	var current_orb = orb
	var match_array = [orb]
	var count_array = []
	var horizontal_count = 1
	var vertical_count = 1
	# right
	while orb_link.has(current_orb.board_position + Vector2(100,0)):
		current_orb = orb_link[current_orb.board_position + Vector2(100,0)]
		if current_orb.orb_type == orb.orb_type:
			horizontal_count += 1
			count_array.append(current_orb)
		else:
			break
	if horizontal_count > 2:
		match_array.append_array(count_array)
	# down
	count_array = []
	current_orb = orb
	while orb_link.has(current_orb.board_position + Vector2(0,100)):
		current_orb = orb_link[current_orb.board_position + Vector2(0,100)]
		if current_orb.orb_type == orb.orb_type:
			vertical_count += 1
			count_array.append(current_orb)
		else:
			break
	if vertical_count > 2:
		match_array.append_array(count_array)
	
	if match_array.size() < 3:
		return []

	return match_array
	
func resolveOrbs(toResolve : Array):
	var final_combos = []
	var stack = []
	stack.append_array(toResolve)
	var current_orb : Orb
	while not stack.is_empty():
		current_orb = stack.pop_back()
		if current_orb.resolved:
			continue
		var count = floodFill(current_orb.board_position, toResolve, current_orb.orb_type)
		final_combos.append([current_orb.orb_type,count])
	
	return final_combos

func floodFill(position : Vector2, array : Array, type : String):
	var total = 0
	if not orb_link.has(position):
		return 0
	
	var orb = orb_link[position]
	if orb.resolved:
		return 0
	
	if orb.orb_type == type and orb_link[orb.position] in array:
		orb.resolved = true
		total += 1
		total += floodFill(orb.position - Vector2(0,100), array, type)
		total += floodFill(orb.position + Vector2(100,0), array, type)
		total += floodFill(orb.position + Vector2(0,100), array, type)
		total += floodFill(orb.position - Vector2(100,0), array, type)
	
	return total

