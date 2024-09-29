extends Attack

func _init(actor:Entity, value:int, target:Entity):
	instance_type = TYPE.ATTACK
	
	self.actor = actor
	self.target = target
	
	final_damage = value
