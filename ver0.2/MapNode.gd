class_name MapNode
extends Sprite2D

enum TYPE {COMBAT, OCCURRENCE, ELITE, SHOP, BOSS, START}
var temp = ["COMBAT", "OCCURRENCE", "ELITE", "SHOP", "BOSS", "START"]
var temp_mapnode_asset_paths = [preload("res://tempassets/CombatNode.png"), 
								preload("res://tempassets/OccurrenceNode.png"), 
								preload("res://tempassets/EliteNode.png"),
								preload("res://tempassets/MarketNode.png"),
								preload("res://tempassets/BossNode.png"),
								preload("res://tempassets/StartNode.png")]

var next : Array[MapNode]
var event : TYPE
var event_name : String

var map_position : int
var floor_position : int

var selectable : bool

func generate(type : TYPE, floor_number : int, node_number : int):
	event = type
	event_name = temp[type]
	texture = temp_mapnode_asset_paths[type]
	
	map_position = node_number
	floor_position = floor_number
	
	position.x = 540 + 300 * node_number
	position.y = 300.5

func _process(_delta):
	if selectable:
		if Input.is_action_just_pressed("click"):
			SignalManager.mapnode_selected.emit(self)

func print_info():
	print("Floor %s, Node %s %s : %s -> %s" % [floor_position, map_position, self, event_name, next])

func _on_hitbox_mouse_entered():
	selectable = true

func _on_hitbox_mouse_exited():
	selectable = false
