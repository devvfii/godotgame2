class_name Enemy
extends Entity_old

var action_roll : int
var attacks : Array[String]
var action_instances : Array[ActionInstance]

var current_intent : ActionInstance

func _ready():
	SignalManager.resized.connect(update_properties)
	set_target([GlobalConstants.player_object])
	set_base()
	update_properties()
	
func update_properties():
	scale = Vector2(1,1) * get_parent().get_current_scale()[1]
	global_position = get_parent().get_global_center() + Vector2(0,60) * get_parent().get_current_scale()[1]

func decide_action():
	current_intent = RngManager.pick_from(action_instances)
	SignalManager.intent_changed.emit(self)

func roll_rng():
	action_roll = RngManager.randi_range(0,99)

func set_target(possible_targets : Array):
	target = RngManager.pick_from(possible_targets)

func set_base():
	var basic_attack = ActionInstance.new(self, target, effective_atk, "ATTACK")
	var basic_block = ActionInstance.new(self, target, effective_block, "BLOCK")
	
	action_instances.append_array([basic_attack, basic_block])
	decide_action()

func resolve_action(_action : ActionInstance):
	print("%s did %s." % [entity_name, current_intent.debug_name])
	target.takeDamage(current_intent.damage)
	
	if not isDead():
		decide_action()
	
	SignalManager.enemy_turn_completed.emit()
