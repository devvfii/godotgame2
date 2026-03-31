extends Entity
class_name Enemy

@export var position_marker : Marker2D

var attack_dict : Dictionary[String,ActionInstance]
var attack_list : Array[ActionInstance]
var attack_weight : Array[float]
var attack_pattern : Array[ActionInstance] # initial temp, will have handling later for operations (parsing from string)
var intent : ActionInstance

func _init(resource : EnemyData = null):
	if resource:
		entity_data = resource
		load_from_resource(resource)
		set_attacks(resource.attack_list, resource.attack_weight)
		if resource.attack_pattern:
			set_attack_pattern(resource.attack_pattern)

func _ready_sub():
	SignalManager.player_turn_completed.connect(_on_turn_started)
	SignalManager.enemy_turn_completed.connect(_on_turn_ended)
	set_sprite_scale(0.35)
	
	if attack_pattern:
		set_intent(attack_pattern[0])
	else:
		set_random_intent()
	
	_ready_custom()

func _ready_custom():
	pass

func assign_position_marker(marker : MarkerNode2D):
	position_marker = marker
	position = position_marker.position

func set_attacks(attacks : Array[ActionInstance], weights : Array[float] = []):
	if attacks.size() != weights.size():
		weights.resize(attacks.size())
		for index in range(weights.size()):
			if not weights[index]:
				weights[index] = 1.0
	
	for index in range(attacks.size()):
		attack_dict[attacks[index].name] = attacks[index]

func set_attack_pattern(pattern : Array[ActionInstance]):
	attack_pattern = pattern

func set_intent(action : ActionInstance):
	if action in attack_dict.values():
		intent = action
		SignalManager.intent_changed.emit(self)

func set_random_intent():
	intent = RngManager.pick_from(attack_list, attack_weight)
	SignalManager.intent_changed.emit(self)

func _on_death():
	pass

func _on_spawned():
	pass

func _on_turn_started():
	pass

func _on_turn_ended():
	pass
