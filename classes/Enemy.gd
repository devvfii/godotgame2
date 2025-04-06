extends Entity
class_name Enemy

var action_roll : int
#AI RNG goes here? this will just hold RNG 0-99. indiv enemy classes will have actions tied into the 0-99
var attacks := ["DEBUFF", "CHARGE", "BIG_SLAM"]
var action_instances : Array[ActionInstance]

var current_intent : ActionInstance

func _ready():
	SignalManager.resized.connect(update_properties)
	entity_name = "Enemy"
	
	# temp setting
	max_hp = 70
	current_hp = 55
	
	var big_slam = ActionInstance.new()
	big_slam.actor = self
	big_slam.target = target
	big_slam.damage = 50
	big_slam.debug_name = "BIG_SLAM"
	
	var debuff = ActionInstance.new()
	debuff.actor = self
	debuff.target = target
	debuff.damage = 20
	debuff.debug_name = "DEBUFF"
	
	var charge = ActionInstance.new()
	charge.actor = self
	charge.target = target
	charge.damage = 0
	charge.debug_name = "CHARGE"
	
	action_instances = [debuff, charge, big_slam]
	
	get_parent().set_entity_owner(self)
	
	update_properties()
	
func update_properties():
	scale = Vector2(1,1) * get_parent().get_current_scale()[1]
	global_position = get_parent().get_global_center() + Vector2(0,60) * get_parent().get_current_scale()[1]

func decide_action():
	current_intent = RngManager.pick_from(action_instances)
	
	SignalManager.intent_changed.emit(self)

func set_target(possible_targets : Array):
	target = RngManager.pick_from(possible_targets)

func resolve_action(action : ActionInstance):
	print("%s did %s." % [entity_name, current_intent.debug_name])
	target.takeDamage(current_intent.damage)
	
	SignalManager.enemy_turn_completed.emit()
