extends Marker2D
class_name MarkerNode2D

@export var left : MarkerNode2D
@export var up : MarkerNode2D
@export var right : MarkerNode2D
@export var down : MarkerNode2D

var next : Array[MarkerNode2D]

var parent : Node

func _ready():
	parent = get_parent()
	get_adjacents()

func get_adjacents() -> Array[MarkerNode2D]:
	var adjacents : Array[MarkerNode2D] = []
	for node in [left, up, right, down]:
		if node:
			adjacents.append(node)
	set_adjacents(adjacents)
	return adjacents

func set_adjacents(adjacents : Array[MarkerNode2D]):
	next = adjacents
