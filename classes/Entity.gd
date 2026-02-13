class_name Entity
extends Sprite2D

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

var charge_storage := 0
var base_charge := 3
var effective_charge := base_charge

var h_flip : bool

func _init(display_name, texture_path):
	setName(display_name)
	texture = load(texture_path)
	visible = false

func setName(name : String):
	entity_name = name

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

func charge(value : int):
	charge_storage += value
	print("%s charged %s orbs." % [entity_name, value])

func resolve_action(action : ActionInstance):
	calculate_effective_stats(action.orb_count)
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

func calculate_effective_stats(orb_count : int):
	var factor = (orb_count - 3) * 0.1
	effective_atk = base_atk * ( 1 + factor)
	effective_block = base_block * ( 1 + factor)
	effective_heal = base_heal * ( 1 + factor)

func turn_completed():
	pass

func isDead():
	return (current_hp <= 0)
	
func die():
	SignalManager.died.emit(self)
	self.queue_free()
