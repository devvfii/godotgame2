class_name HealthBar
extends Control

@export var entity_owner : Entity

@onready var texture = $Texture
@onready var label = $HealthLabel

func _ready():
	SignalManager.entity_damaged.connect(update_hp)

func update_hp(entity : Entity):
	if entity_owner == entity:
		texture.value = entity.current_hp
		label.text = "%s / %s" % [entity.current_hp, entity.max_hp]
