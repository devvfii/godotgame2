extends Sprite2D
class_name Entity

var entity_name : String

var target : Entity

var max_hp := 100.0
var current_hp := max_hp
var current_block := 0.0
var base_atk := 5.0
var effective_atk := base_atk
var base_block := 5.0
var effective_block := base_block
var base_heal := 3.0
var effective_heal := base_heal

var sprite : AnimatedSprite2D
var h_flip : bool

func takeDamage(damage : int):
	current_hp -= damage
	print("%s has %s hp left." % [entity_name, current_hp])
	
	SignalManager.damaged.emit(self)
	if isDead():
		die()

func heal(value : int):
	current_hp += value
	if current_hp > max_hp:
		current_hp = max_hp
	
	SignalManager.damaged.emit(self)
	print("%s healed %s hp." % [entity_name, value])

func block(value : int):
	current_block += value
	print("%s blocked for %s." % [entity_name, value])

func resolve_action(action : ActionInstance):
	calculate_effective_stats(action.orb_count - 2)
	
	match action.instance_type:
		0:
			# MATTACK
			target.takeDamage(effective_atk)
		1:
			# RATTACK
			target.takeDamage(effective_atk)
		2:
			# BLOCK
			self.block(effective_block)
		3:
			# HEAL
			self.heal(effective_heal)

func calculate_effective_stats(factor : int):
	effective_atk = base_atk * factor
	effective_block = base_block * factor
	effective_heal = base_heal * factor

func isDead():
	return (current_hp <= 0)
	
func die():
	SignalManager.died.emit(self)
	self.queue_free()
