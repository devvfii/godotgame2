extends Control
class_name OrbTile

@onready var center = $Center
@onready var hitbox = $Hitbox
@onready var background = $Background

@export var texture : Texture

var orb : Orb
var turn_state := GlobalConstants.TURN_STATES.PLANNING

func _ready() -> void:
	background.texture = texture
	_on_resized()
	
	SignalManager.state_changed.connect(_on_turn_state_change)

func get_center() -> Vector2:
	return center.global_position

func _on_turn_state_change(state : GlobalConstants.TURN_STATES) -> void:
	turn_state = state

func _on_resized() -> void:
	center.position = size / 2.0
	hitbox.position = center.position
	hitbox.get_child(0).shape.radius = size.x / 2.0

func _on_hitbox_mouse_entered() -> void:
	match turn_state:
		GlobalConstants.TURN_STATES.EXECUTION:
			# swap orb
			pass
		_:
			pass

func _on_hitbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_just_pressed("click"):
		# select orb
		pass
	if event.is_action_just_released("click"):
		# drop orb
		match turn_state:
			GlobalConstants.TURN_STATES.EXECUTION:
				#drop orb
				pass
			_:
				#unselect orb
				pass
