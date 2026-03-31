extends Control

@onready var markers = $Markers
@onready var enemies = $Enemies

@onready var debug_enemy = $DebugEnemy

var spawn_positions : Dictionary

func _ready():
	SignalManager.debug_spawn_enemy.connect(spawn_enemy)
	
	for marker in markers.get_children():
		spawn_positions[marker] = null

func _process(_delta):
	pass

func find_spawnable_spaces() -> Array[MarkerNode2D]:
	var empty_spaces : Array[MarkerNode2D] = []
	for space in spawn_positions.keys():
		if !spawn_positions[space]:
			empty_spaces.append(space)
	
	return empty_spaces

func spawn_enemy():
	var spawn_location = RngManager.pick_from(find_spawnable_spaces())
	
	if !spawn_location:
		print("No more locations")
		return
		
	print("Spawning enemy at %s" % [spawn_location])
	spawn_positions[spawn_location] = "temp"
