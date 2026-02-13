class_name Player
extends Entity

func _init(display_name):
	setName(display_name)
	texture = preload("res://tempassets/player.png")
	visible = false
	GlobalConstants.player_object = self
	set_base_stats()

# option select functionality
func _ready():
	SignalManager.resized.connect(update_properties)
	SignalManager.full_turn_completed.connect(turn_completed)
	
func update_properties():
	scale = Vector2(0.26,0.26) * get_parent().get_current_scale()[1]
	global_position = get_parent().get_global_center() + Vector2(0,60) * get_parent().get_current_scale()[1]

func set_base_stats():
	max_hp = 100.0
	base_atk = 10.0
	base_block = 5.0
	base_heal = 3.0
	base_charge = 3
	
	current_hp = max_hp

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
