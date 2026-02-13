class_name HealthBar
extends CustomControl

func _ready():
	SignalManager.resized.connect(update_properties)
	SignalManager.damaged.connect(update_hp)

	base_size = size
	update_properties()

func update_hp(entity : Entity):
	if entity_owner == entity:
		$Texture.value = entity.current_hp
		$HealthLabel.text = "%s / %s" % [entity.current_hp, entity.max_hp]
