class_name Constants
extends Node

enum DIRECTION {UP, UP_RIGHT, RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT, LEFT, UP_LEFT}

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

const CHARACTERS = {
	"Slime" : preload("res://ver0.2/Slime.tscn"),
	"Efi" : preload("res://ver0.2/Character.tscn")
}

var player_object
