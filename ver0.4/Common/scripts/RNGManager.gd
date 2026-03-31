extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func get_seed():
	return rng.seed

func get_state():
	return rng.state

func set_seed(rng_seed : int):
	rng.set_seed(rng_seed)

func set_state(state : int):
	rng.set_state(state)

func pick_from(input_array : Array, weights : Array[float] = []):
	if input_array.is_empty():
		return null
	if weights.is_empty():
		weights.resize(input_array.size())
		weights.fill(1)
	return input_array[rng.rand_weighted(weights)]

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
