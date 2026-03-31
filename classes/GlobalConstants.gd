class_name Constants_Old
extends Node

enum DIRECTION {UP, UP_RIGHT, RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT, LEFT, UP_LEFT}
enum TURN_STATES {PLANNING, EXECUTION, RESOLUTION, ENEMY}

const DIRECTION_MAP = {
	"left" : DIRECTION.LEFT,
	"right" : DIRECTION.RIGHT,
	"up_left" : DIRECTION.UP_LEFT,
	"up_right" : DIRECTION.UP_RIGHT,
	"down_left" : DIRECTION.DOWN_LEFT,
	"down_right" : DIRECTION.DOWN_RIGHT,
	"up" : DIRECTION.UP,
	"down" : DIRECTION.DOWN
}

const TURN_STATES_MAP = {
	"planning" : TURN_STATES.PLANNING,
	"execution" : TURN_STATES.EXECUTION,
	"resolution" : TURN_STATES.RESOLUTION,
	"enemy" : TURN_STATES.ENEMY
}

const CHARACTERS = {
	"Slime" : preload("res://ver0.2/Slime.tscn"),
	"Efi" : preload("res://ver0.2/Character.tscn")
}

var player_object
