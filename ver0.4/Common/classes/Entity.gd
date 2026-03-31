class_name Entity
extends Sprite2D

var display_name : String
var target : Entity

var h_flip : bool

var max_hp : float = 100.0
var current_hp : float = max_hp
var current_block : float = 0.0

var base_atk : float = 5.0
var effective_atk : float = base_atk

var base_block : float = 5.0
var effective_block : float = base_block

var base_heal : float = 3.0
var effective_heal : float = base_heal

var base_charge : float = 3
var effective_charge : float = base_charge
var charge_storage : float = 0

@export var entity_data : EntityData

func _ready():
	#Set signals
	
	_ready_sub()

func _ready_sub():
	pass

func block(value : int):
	current_block += value
	SignalManager.entity_blocked.emit(self, value)
	#SignalManager.debug_log.emit("%s blocked for %s." % [display_name, value])

func charge(value : int):
	charge_storage += value
	SignalManager.entity_charged.emit(self, value)
	#SignalManager.debug_log.emit("%s charged %s orbs." % [display_name, value])

func die():
	SignalManager.entity_died.emit(self)
	queue_free()

func load_from_resource(resource : EntityData):
	display_name = resource.display_name
	texture = resource.texture

	max_hp = resource.max_hp
	current_hp = max_hp
	
	base_atk = resource.base_atk
	effective_atk = base_atk
	
	base_block = resource.base_block	
	effective_block = base_block
	
	base_heal = resource.base_heal
	effective_heal = base_heal
	
	base_charge = resource.base_charge
	effective_charge = base_charge

func resolve_action(action : ActionInstance):
	match action.instance_type:
		ActionInstance.TYPE.MATTACK:
			target.take_damage(effective_atk)
		ActionInstance.TYPE.RATTACK:
			target.take_damage(effective_atk)
		ActionInstance.TYPE.BLOCK:
			block(effective_block)
		ActionInstance.TYPE.HEAL:
			heal(effective_heal)

func heal(value : int):
	current_hp += value
	SignalManager.entity_healed.emit(self, value)
	
	if current_hp > max_hp:
		current_hp = max_hp
	
	#SignalManager.debug_log.emit("%s healed %s hp." % [display_name, value])

func set_display_name(entity_name : String):
	display_name = entity_name

func set_sprite_scale(scale_var : float):
	scale = Vector2(scale_var,scale_var)

func set_sprite_visibility(setting : bool):
	visible = setting

func take_damage(damage : int):
	current_block -= damage
	
	if current_block < 0:
		current_hp += current_block
		current_block = 0 
		SignalManager.entity_block_broken.emit(self)
	
	SignalManager.entity_damaged.emit(self, damage)
	
	if current_hp <= 0:
		die()
	
	#SignalManager.debug_log.emit("%s has %s hp left." % [display_name, current_hp])
