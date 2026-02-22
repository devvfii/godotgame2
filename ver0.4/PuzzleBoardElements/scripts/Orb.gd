extends Sprite2D
class_name Orb

enum TYPE {MELEE, RANGED, BLOCK, HEAL, CHARGE, JAMMER, BOMB}
enum COLOR {YELLOW, GREEN, BLUE, PINK, RED, STAR, BOMB}

@onready var sprite = $Sprite2D

var orb_asset_paths = {
	COLOR.YELLOW : "res://tempassets/yellowOrb.png",
	COLOR.GREEN : "res://tempassets/greenOrb.png",
	COLOR.BLUE : "res://tempassets/blueOrb.png",
	COLOR.PINK : "res://tempassets/pinkOrb.png",
	COLOR.RED : "res://tempassets/redOrb.png"
}

var loaded_texture : CompressedTexture2D

var orb_type : String
var orb_color : String

var parent_tile : OrbTile

var selected : bool = false
var resolved : bool = false

var spawned : bool = false
var deleted : bool = false

const MOUSE_FOLLOW_SPEED = 10.0
const SWAP_SPEED = 1250.0
const TRANSPARENCY_SPEED = 2.0

func _ready():
	SignalManager.orb_selected.connect(orb_selected)
	SignalManager.orb_resized.connect(orb_resized)
	
	sprite.texture = load(orb_asset_paths[COLOR.get(orb_color)])
	sprite.position = global_position + Vector2(0,-550)
	sprite.self_modulate.a = 0.0
	spawned = true

func _physics_process(delta):
	if sprite.position.y < 0:
		sprite.visible = false
	else:
		sprite.visible = true
	
	if spawned:
		sprite.self_modulate.a = move_toward(sprite.self_modulate.a, 1.0, delta * TRANSPARENCY_SPEED)
		if sprite.self_modulate.a == 1.0:
			spawned = false

	if selected:
		global_position = get_global_mouse_position()
		sprite.global_position = get_global_mouse_position()
	elif sprite.global_position != global_position:
		sprite.global_position = sprite.global_position.move_toward(global_position, delta * SWAP_SPEED)
	
	if resolved or deleted:
		sprite.self_modulate.a = move_toward(sprite.self_modulate.a, 0.0, delta * TRANSPARENCY_SPEED)
		if sprite.self_modulate.a == 0.0:
			SignalManager.orb_deleted.emit(self)
			self.queue_free()

func newOrb(type : int, parent_tile : OrbTile):
	orb_type = TYPE.find_key(type)
	orb_color = COLOR.find_key(type)
	self.parent_tile = parent_tile
	global_position = parent_tile.center_global_position

func orb_selected(orb : Orb):
	selected = orb == self

func orb_dropped():
	selected = false
	snapTo(parent_tile.center_global_position)

func orb_resized(tile_size : float):
	var new_scale = tile_size / sprite.texture.get_size().x
	sprite.scale = Vector2(new_scale, new_scale)

func moveTo(dest : Vector2):
	position = dest

func snapTo(dest : Vector2):
	position = dest
	sprite.position = dest

func queue_for_deletion():
	deleted = true
