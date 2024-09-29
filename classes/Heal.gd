extends ActionInstance

var final_heal : int

func _init(actor:Entity, orb_count:int, special_string):
	instance_type = TYPE.HEAL
	
	self.actor = actor
	self.target = actor
	
	self.orb_count = orb_count
		
	if special_string in SPECIALS:
		self.is_special = true
		self.special_type = SPECIALS.get(special_string)
		
	healCalc()
	#do special effect


func healCalc():
	final_heal = int(actor.effective_heal + actor.effective_heal * 0.2 * (orb_count - 3))
