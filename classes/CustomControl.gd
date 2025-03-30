extends Control
class_name CustomControl

var base_size : Vector2
var current_scale := Vector2(1,1)
var global_center : Vector2

var entity_owner : Entity

func _ready():
	SignalManager.resized.connect(update_properties)
	SignalManager.died.connect(owner_died)


func set_entity_owner(entity : Entity):
	entity_owner = entity

func get_current_scale():
	return current_scale

func get_global_center():
	return global_center

func update_properties():
	current_scale = Vector2(size[0]/base_size[0], size[1]/base_size[1])
	global_center = Vector2((global_position.x + size[0]/2), (global_position.y + size[1]/2))

func owner_died(entity : Entity):
	if entity == entity_owner:
		entity_owner = null

func _on_resized():
	SignalManager.resized.emit()

func _on_tree_entered():
	base_size = size
	update_properties()
