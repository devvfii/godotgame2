extends Entity
class_name Player

# option select functionality
func _ready():
	SignalManager.resized.connect(update_properties)
	
	entity_name = "Psi"
	get_parent().set_entity_owner(self)
	
	update_properties()
	
func update_properties():
	scale = Vector2(0.26,0.26) * get_parent().get_current_scale()[1]
	global_position = get_parent().get_global_center() + Vector2(0,60) * get_parent().get_current_scale()[1]
