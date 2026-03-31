class_name ActionInstance
extends Resource

enum TYPE {MATTACK, RATTACK, BLOCK, HEAL, CHARGE}
enum SPECIALS {PLUS, TSHAPE, LSHAPE, BLOCK}
enum RANGE {SINGLE = 3, PIERCE = 4, AOE = 5}

var actor : Entity
var target : Entity

var instance_type : TYPE
var special_type : SPECIALS
var is_special := false

var orb_count : int
@export var damage : int
@export var name : String

func _init(action_actor : Entity, action_target : Entity, action_damage : int, action_type : String = "", action_name : String = ""):
	actor = action_actor
	target = action_target
	damage = action_damage
	name = action_name
	instance_type = GlobalConstants.ORB_ACTION_MAP[action_type.to_lower()]
