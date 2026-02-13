class_name BigCharacterBox
extends Control

const SNAP_THRESHOLD = 0.001

@onready var character = $Character
@onready var marker = $Marker2D
@onready var state_animation_player = $Character/StateAnimationPlayer
@onready var action_animation_player = $ActionAnimationPlayer
@onready var focus_animation_player = $Focus

var target_anchor := 0.5
var current_anchor : float

var character_name : String

var paused : bool = false

func play_idle_animation():
	state_animation_player.play("idle")

func pause():
	paused = true

func unpause():
	paused = false

func focus():
	focus_animation_player.play("focus")

func unfocus(value = 0.5):
	focus_animation_player.get_animation("unfocus").track_set_key_value(0, 1, Color(value, value, value, 1))
	focus_animation_player.get_animation("focus").track_set_key_value(0, 0, Color(value, value, value, 1))
	focus_animation_player.play("unfocus")

func enter(from_direction : String, target_pos := "0.5"):
	target_anchor = target_pos.to_float()
	snap()
	visible = true
	match Constants.DIRECTION_MAP[from_direction.to_lower()]:
		Constants.DIRECTION.LEFT:
			action_animation_player.play("enter_left")
		Constants.DIRECTION.RIGHT:
			action_animation_player.play("enter_right")
		Constants.DIRECTION.UP:
			action_animation_player.play("enter_up")
		Constants.DIRECTION.DOWN:
			action_animation_player.play("enter_down")
		Constants.DIRECTION.UP_RIGHT:
			action_animation_player.play("enter_up_right")
		Constants.DIRECTION.DOWN_RIGHT:
			action_animation_player.play("enter_down_right")
		Constants.DIRECTION.UP_LEFT:
			action_animation_player.play("enter_up_left")
		Constants.DIRECTION.DOWN_LEFT:
			action_animation_player.play("enter_down_left")

func exit(to_direction : String):
	match Constants.DIRECTION_MAP[to_direction.to_lower()]:
		Constants.DIRECTION.LEFT:
			action_animation_player.play("exit_left")
		Constants.DIRECTION.RIGHT:
			action_animation_player.play("exit_right")
		Constants.DIRECTION.UP:
			action_animation_player.play("exit_up")
		Constants.DIRECTION.DOWN:
			action_animation_player.play("exit_down")
		Constants.DIRECTION.UP_RIGHT:
			action_animation_player.play("exit_up_right")
		Constants.DIRECTION.DOWN_RIGHT:
			action_animation_player.play("exit_down_right")
		Constants.DIRECTION.UP_LEFT:
			action_animation_player.play("exit_up_left")
		Constants.DIRECTION.DOWN_LEFT:
			action_animation_player.play("exit_down_left")

func move(anchor_point : float):
	anchor_left = anchor_point
	anchor_right = anchor_point

func snap():
	anchor_left = target_anchor
	anchor_right = target_anchor

func slide_to(reference):
	match type_string(typeof(reference)):
		"String":
			target_anchor = reference.to_float()
		"Object":
			if reference is BigCharacterBox:
				target_anchor = reference.target_anchor

func shake_1d(direction : String = "left"):
	match Constants.DIRECTION_MAP[direction.to_lower()]:
		Constants.DIRECTION.LEFT, Constants.DIRECTION.RIGHT:
			pass
		Constants.DIRECTION.UP, Constants.DIRECTION.DOWN:
			pass
		Constants.DIRECTION.UP_LEFT, Constants.DIRECTION.DOWN_RIGHT:
			pass
		Constants.DIRECTION.UP_RIGHT, Constants.DIRECTION.DOWN_LEFT:
			pass

func bounce():
	action_animation_player.play("RESET")
	action_animation_player.play("bounce")

func drop():
	action_animation_player.play("RESET")
	action_animation_player.play("drop")

func calculate_weight(delta):
	return 1 - exp(-5 * delta)

static func new_character(name : String):
	var scene = load("res://ver0.2/BigCharacterBox.tscn")
	var new_char = Constants.CHARACTERS[name].instantiate()
	var new_scene = scene.instantiate()
	new_scene.add_child(new_char)
	new_scene.character_name = name
	new_scene.visible = false
	return new_scene
	
func _ready():
	marker.self_modulate = Color(1,1,1,0)

func _process(delta):
	if target_anchor != anchor_left:
		current_anchor = lerp(anchor_left, target_anchor, calculate_weight(delta))
		move(current_anchor)
		character.position = marker.position
	if abs(anchor_left-target_anchor) < SNAP_THRESHOLD:
		snap()
		character.position = marker.position
	character.modulate = marker.self_modulate

func _on_state_animation_player_animation_finished(anim_name):
	if !paused:
		play_idle_animation()
