extends Area2D
class_name Hitbox

@onready var collision = $CollisionShape2D

var parent_node : Orb

func _ready():
	parent_node = get_parent()
