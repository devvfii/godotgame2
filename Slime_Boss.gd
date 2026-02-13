class_name Slime_Boss
extends Enemy

var big_slam
var debuff
var charge_slam

	
func set_base_stats():
	max_hp = 90.0
	
	current_hp = 55
	
func set_base():
	set_base_stats()
	
	big_slam = ActionInstance.new(self, target, 50, "BIG_SLAM")
	debuff = ActionInstance.new(self, target, 20, "DEBUFF")
	charge_slam = ActionInstance.new(self, target, 0, "CHARGE_SLAM")
	
	current_intent = big_slam
	decide_action()

func decide_action():
	match current_intent.debug_name:
		"CHARGE_SLAM":
			action_instances = [big_slam]
		"DEBUFF":
			action_instances = [charge_slam]
		"BIG_SLAM":
			action_instances = [debuff]

	current_intent = RngManager.pick_from(action_instances)

	SignalManager.intent_changed.emit(self)
