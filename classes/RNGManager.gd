extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func get_seed():
	return rng.seed

func get_state():
	return rng.state

func set_seed(seed : int):
	rng.set_seed(seed)

func set_state(state : int):
	rng.set_state(state)

func pick_from(input_array : Array, weights : Array = []):
	if len(weights) == 0:
		return input_array[rng.randi_range(0,len(input_array)-1)]
	
	var temp = []
	var temp2 = []
	for i in weights:
		for j in range(i):
			temp2 = []
			temp2.append(i)
		temp.append_array(temp2)
	
	return input_array[rng.randi_range(0,len(temp)-1)]

func randf():
	return rng.randf()

func randf_range(from: float, to : float):
	return rng.randf_range(from, to)

func randfn(mean : float = 0.0, deviation : float = 1.0):
	return rng.randfn(mean, deviation)

func randi():
	return rng.randi()

func randi_range(from : int, to : int):
	return rng.randi_range(from, to)

func randomize():
	rng.randomize()
