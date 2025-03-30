extends CustomControl
class_name HealthBar

func _ready():
	SignalManager.resized.connect(update_properties)
	SignalManager.damaged.connect(update_hp)
	
	set_entity_owner(get_parent().entity_owner)
	
	base_size = size
	update_hp(entity_owner)
	update_properties()

func update_hp(entity : Entity):
	if entity_owner == entity:
		$Texture.value = entity.current_hp
		$HealthLabel.text = "%s / %s" % [entity.current_hp, entity.max_hp]
