class_name ActionInstance

enum TYPE {MATTACK, RATTACK, BLOCK, HEAL}
enum SPECIALS {PLUS, TSHAPE, LSHAPE, BLOCK}

var actor : Entity
var target : Entity

var instance_type : TYPE
var orb_count : int
var is_special := false
var special_type : SPECIALS
