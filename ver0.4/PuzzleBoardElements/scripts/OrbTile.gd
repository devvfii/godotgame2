extends Control
class_name OrbTile

@onready var hitbox = $Hitbox
@onready var background = $Background
@onready var orb_container = %OrbContainer

@export var texture : Texture

var orb_scene = preload("res://ver0.4/PuzzleBoardElements/scenes/orb.tscn")


var center_global_position : Vector2

var up : OrbTile
var right : OrbTile
var down : OrbTile
var left : OrbTile

var selected_orb : Orb
var orb : Orb
var turn_state := GlobalConstants.TURN_STATES.PLANNING

func _ready() -> void:
	background.texture = texture
	_on_resized()
	
	SignalManager.state_changed.connect(_on_turn_state_change)
	SignalManager.orb_selected.connect(_on_orb_selected)
	SignalManager.orb_dropped.connect(_on_orb_dropped)
	SignalManager.generate_orbs.connect(generate_orb)

func generate_orb() -> void:
	if not is_instance_valid(orb):
		var rng = RngManager.randi_range(0,4)
		orb = orb_scene.instantiate() as Orb
		orb.newOrb(rng, self)
	
	if not orb.is_inside_tree():
		orb_container.add_child(orb)
		orb.orb_resized(size.x)
		

func swap_orb(selected_orb : Orb, current_orb : Orb):
	var tile_swapped_with = selected_orb.parent_tile
	
	tile_swapped_with.orb = current_orb
	self.orb = selected_orb
	
	current_orb.parent_tile = tile_swapped_with
	selected_orb.parent_tile = self
	
	current_orb.moveTo(tile_swapped_with.center_global_position)

func _on_turn_state_change(state : GlobalConstants.TURN_STATES) -> void:
	turn_state = state

func _on_orb_selected(selected_orb : Orb):
	self.selected_orb = selected_orb

func _on_orb_dropped(_orb_dropped : Orb):
	self.selected_orb = null

func _on_resized() -> void:
	if is_instance_valid(hitbox):
		hitbox.position = size / 2.0
		hitbox.get_child(0).shape.radius = size.x / 2.0
		center_global_position = global_position + size / 2.0
	if is_instance_valid(orb):
		orb.snapTo(center_global_position)

func _on_hitbox_mouse_entered() -> void:
	
	match turn_state:
		GlobalConstants.TURN_STATES.PLANNING:
			if selected_orb and orb != selected_orb:
				SignalManager.state_changed.emit(GlobalConstants.TURN_STATES.EXECUTION)
				swap_orb(selected_orb, orb)
		GlobalConstants.TURN_STATES.EXECUTION:
			if orb != selected_orb:
				swap_orb(selected_orb, orb)
		_:
			pass

func _on_hitbox_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		SignalManager.orb_selected.emit(orb)
