extends Entity
class_name Player

@export var position_marker : Marker2D

func _ready_sub():
	position = position_marker.position
	if entity_data:
		load_from_resource(entity_data)
	set_sprite_scale(0.35)

func calculate_effective_stats(orb_count : int = 3):
	var factor : float = (orb_count - 3) * 0.1
	effective_atk = base_atk * ( 1 + factor)
	effective_block = base_block * ( 1 + factor)
	effective_heal = base_heal * ( 1 + factor)

func resolve_action(action : ActionInstance):
	calculate_effective_stats(action.orb_count)
	match action.instance_type:
		ActionInstance.TYPE.MATTACK:
			target.take_damage(effective_atk)
		ActionInstance.TYPE.RATTACK:
			target.take_damage(effective_atk)
		ActionInstance.TYPE.BLOCK:
			block(effective_block)
		ActionInstance.TYPE.HEAL:
			heal(effective_heal)
