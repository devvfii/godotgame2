class_name Hitbox
extends Area2D

@onready var collision = $CollisionShape2D

var parent_node

func _ready():
	parent_node = get_parent()
