extends ActionInstance
class_name Attack

enum RANGE {SINGLE = 3, PIERCE = 4, AOE = 5}

var final_damage : float
var attack_type : RANGE

func _init(actor:Entity, orb_count:int, special_string, target:Entity):
	instance_type = TYPE.ATTACK
	
	self.actor = actor
	self.target = target
	
	self.orb_count = orb_count
	if orb_count > 4:
		attack_type = RANGE.AOE
	elif orb_count > 3:
		attack_type = RANGE.PIERCE
	else:
		attack_type = RANGE.SINGLE
		
	if special_string in SPECIALS:
		self.is_special = true
		self.special_type = SPECIALS.get(special_string)
		
	damageCalc()
	#do special effect


func damageCalc():
	final_damage = int(actor.effective_atk + actor.effective_atk * 0.2 * (orb_count - 3))
