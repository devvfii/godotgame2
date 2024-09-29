extends Entity
class_name Enemy

var action_roll : int
#AI RNG goes here? this will just hold RNG 0-99. indiv enemy classes will have actions tied into the 0-99

func decideAction():
	action_roll = randi_range(0, 99)

func decideTarget(possible_targets:Array[Entity]):
	return possible_targets.pick_random()
