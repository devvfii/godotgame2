extends Sprite2D
class_name Orb

enum TYPE {MELEE, RANGED, BLOCK, HEAL, CHARGE, JAMMER, BOMB}
enum COLOR {YELLOW, GREEN, BLUE, PINK, RED, STAR, BOMB}

@onready var hitbox = $Hitbox

var orb_type : String
var orb_color : String

var board_position : Vector2

var selectable : bool = false
var selected : bool = false
var resolved : bool = false

func _ready():
	SignalManager.orb_selected.connect(orb_selected)
	SignalManager.orb_dropped.connect(orb_dropped)

func _process(_delta):
	if selectable or selected:
		if Input.is_action_pressed("click"):
			if Input.is_action_just_pressed("click"):
				SignalManager.orb_selected.emit(self)
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("click"):
			SignalManager.orb_dropped.emit(self)

func _on_hitbox_mouse_entered():
	selectable = true

func _on_hitbox_mouse_exited():
	selectable = false

func _on_hitbox_body_entered(body):
	if selected and body.get_parent() is Orb:
		SignalManager.orb_swap.emit(self, body.get_parent())

func newOrb(type : int, image , initial_position : Vector2):
	orb_type = TYPE.find_key(type)
	orb_color = COLOR.find_key(type)
	texture = image
	position = initial_position
	board_position = initial_position

func orb_selected(orb : Orb):
	if orb == self:
		selected = true
	else:
		selectable = false

func orb_dropped(orb : Orb):
	if orb == self:
		selected = false

func moveTo(dest : Vector2):
	position = dest
	board_position = dest

