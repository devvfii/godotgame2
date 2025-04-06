extends ActionInstance

var final_block : int

func _init(actor:Entity, orb_count:int, special_string):
	instance_type = TYPE.BLOCK
	
	self.actor = actor
	self.target = actor
	
	self.orb_count = orb_count
		
	if special_string in SPECIALS:
		self.is_special = true
		self.special_type = SPECIALS.get(special_string)
		
	blockCalc()
	#do special effect


func blockCalc():
	final_block = int(actor.effective_block + actor.effective_block * 0.2 * (orb_count - 3))
