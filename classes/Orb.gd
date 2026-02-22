class_name Orb_old
extends Sprite2D

enum TYPE {MELEE, RANGED, BLOCK, HEAL, CHARGE, JAMMER, BOMB}
enum COLOR {YELLOW, GREEN, BLUE, PINK, RED, STAR, BOMB}

@onready var hitbox = $Hitbox
@onready var sprite = $Sprite2D

var loaded_texture : CompressedTexture2D

var orb_type : String
var orb_color : String

var board_position : Vector2

var selectable : bool = false
var selected : bool = false
var resolved : bool = false

var spawned : bool = false
var deleted : bool = false
var temp_disable : bool = false

var last_swapped_with : Array = []

const FOLLOW_SPEED = 10.0

func _ready():
	SignalManager.orb_selected.connect(orb_selected)
	SignalManager.orb_dropped.connect(orb_dropped)
	
	sprite.texture = loaded_texture
	sprite.position = global_position + Vector2(0,-550)
	sprite.self_modulate.a = 0.0
	spawned = true

func _physics_process(delta):
	if sprite.position.y < 250:
		sprite.visible = false
	else:
		sprite.visible = true
	
	if spawned:
		sprite.self_modulate.a = move_toward(sprite.self_modulate.a, 1.0, delta * 2.0)
		if sprite.self_modulate.a == 1.0:
			spawned = false
	
	if selectable:
		if Input.is_action_just_pressed("click"):
			SignalManager.orb_selected.emit(self)
		elif Input.is_action_just_released("click"):
			SignalManager.orb_dropped.emit(self)

	if selected:
		global_position = global_position.lerp(get_global_mouse_position(), delta * FOLLOW_SPEED)
		sprite.global_position = global_position
		if last_swapped_with.size() > 0:
			if self.hitbox.overlaps_area(last_swapped_with[0].hitbox) and global_position.distance_to(last_swapped_with[0].board_position) < last_swapped_with[1]:
				orb_swap(last_swapped_with[0])
	elif sprite.global_position != global_position:
		sprite.global_position = sprite.global_position.move_toward(global_position, delta * 1250.0)
	
	if resolved or deleted:
		sprite.self_modulate.a = move_toward(sprite.self_modulate.a, 0.0, delta * 2.0)
		if sprite.self_modulate.a == 0.0:
			SignalManager.orb_deleted.emit(self)
			self.queue_free()

func _on_hitbox_mouse_entered():
	if not temp_disable:
		selectable = true

func _on_hitbox_mouse_exited():
	if not temp_disable:
		selectable = false

func _on_hitbox_body_entered(body):
	if selected and body.get_parent() is Orb_old:
		orb_swap(body.get_parent())

func newOrb(type : int, image , initial_position : Vector2):
	orb_type = TYPE.find_key(type)
	orb_color = COLOR.find_key(type)
	loaded_texture = image
	position = initial_position
	board_position = initial_position

func orb_selected(orb : Orb_old):
	if orb == self:
		selected = true
	else:
		temp_disable = true
		if SignalManager.orb_selected.is_connected(orb_selected):
			SignalManager.orb_selected.disconnect(orb_selected)

func orb_dropped(orb : Orb_old):
	if orb == self:
		selected = false
	else:
		temp_disable = false
		if !SignalManager.orb_selected.is_connected(orb_selected):
			SignalManager.orb_selected.connect(orb_selected)

func orb_swap(orb : Orb_old):
	var temp_position = board_position
	board_position = orb.board_position
	orb.board_position = temp_position
	
	orb.moveTo(orb.board_position)
	
	last_swapped_with = [orb, global_position.distance_to(orb.board_position)]
	
	SignalManager.orb_swapped.emit(self, orb)

func moveTo(dest : Vector2):
	position = dest
	board_position = dest

func queue_for_deletion():
	deleted = true
