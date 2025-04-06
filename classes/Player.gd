extends Entity
class_name Player

# option select functionality
func _ready():
	SignalManager.resized.connect(update_properties)
	SignalManager.full_turn_completed.connect(turn_completed)
	
	entity_name = "Psi"
	get_parent().set_entity_owner(self)
	
	update_properties()
	
func update_properties():
	scale = Vector2(0.26,0.26) * get_parent().get_current_scale()[1]
	global_position = get_parent().get_global_center() + Vector2(0,60) * get_parent().get_current_scale()[1]

func turn_completed():
	effective_atk = base_atk
	effective_block = base_block
	effective_heal = base_heal
	
	if current_block > 0:
		print("%s block has expired." % [current_block])
		current_block = 0
	
	if effective_charge > base_charge:
		var excess = effective_charge - base_charge
		excess = int(excess / 2)
		effective_charge = base_charge + excess
		
		print("%s charge has expired." % [excess])
	else:
		effective_charge = base_charge
	
	effective_charge += charge_storage
	charge_storage = 0
