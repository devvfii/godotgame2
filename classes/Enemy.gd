extends Entity
class_name Enemy

var action_roll : int
#AI RNG goes here? this will just hold RNG 0-99. indiv enemy classes will have actions tied into the 0-99

func _ready():
	SignalManager.resized.connect(update_properties)
	entity_name = "Enemy"
	
	max_hp = 50
	current_hp = 45
	
	get_parent().set_entity_owner(self)
	
	update_properties()
	
func update_properties():
	scale = Vector2(1,1) * get_parent().get_current_scale()[1]
	global_position = get_parent().get_global_center() + Vector2(0,60) * get_parent().get_current_scale()[1]

func decideAction():
	action_roll = randi_range(0, 99)

func decideTarget(possible_targets:Array[Entity]):
	return possible_targets.pick_random()
