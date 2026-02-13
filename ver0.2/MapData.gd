class_name Map
extends CustomControl

enum SIZE {SMALL = 7, MEDIUM = 10, LARGE = 13}

var mapnode_scene = preload("res://ver0.2/MapNode.tscn")
@onready var scroll_container = $"Nodes"
@onready var mapnode_container = $"Nodes/Control"
@onready var mapnode_panel = $"Nodes/Control/Background"


var nodes : Array[MapNode]
var start : MapNode

var length : SIZE
var empty_map : Array = []
var branch_chance := 0.80

var branches : int
var floor : int
var number : int
var new_node : MapNode
var current_nodes : Array[MapNode]
var prev_nodes : Array[MapNode]
var elites : Array

var current_position : MapNode

func _ready():
	SignalManager.mapnode_selected.connect(move_player)

func generate(map_size : SIZE):
	for i in mapnode_container.get_children():
		if i is MapNode:
			i.queue_free()
	
	nodes = []
	empty_map = []
	branches = 1
	elites = []
	
	elites.append(RngManager.pick_from([3,4,5],[1,2,1]))
	
	match map_size:
		SIZE.SMALL:
			floor = 1
			branch_chance = 2.0 / 3.0
		SIZE.MEDIUM:
			floor = 2
			branch_chance = 0.7
			
			elites.append(RngManager.pick_from([6,7,8],[1,2,1]))
		SIZE.LARGE:
			floor = 3
			branch_chance = 0.8
			
			elites.append(RngManager.pick_from([6,7,8],[1,2,1]))
			elites.append(RngManager.pick_from([9,10,11],[1,2,1]))

	for i in range(map_size):
		empty_map.append(branches)
		if RngManager.randf() < branch_chance:
			match branches:
				1:
					branches = 2
				2:
					branches = 1
			branch_chance = 1.0 - branch_chance
	
	new_node = mapnode_scene.instantiate()
	new_node.generate(5,floor,0)
	mapnode_container.add_child(new_node)
	
	start = new_node
	current_position = start
	nodes.append(new_node)
	
	prev_nodes = [new_node]
	number = 1
	
	for i in empty_map:
		current_nodes = []
		
		for j in range(i):
			new_node = mapnode_scene.instantiate()
			if number in elites:
				new_node.generate(2, floor, number)
			elif i == map_size:
				new_node.generate(4, floor, number)
			elif RngManager.randf() < 0.6:
				new_node.generate(0, floor, number)
			else:
				new_node.generate(1, floor, number)
			
			if i == 2:
				match j:
					0:
						new_node.position.y -= 150
					1:
						new_node.position.y += 150
						
			current_nodes.append(new_node)
			mapnode_container.add_child(new_node)
		
		match len(prev_nodes):
			1:
				prev_nodes[0].next = current_nodes
			2:
				if len(current_nodes) == 2:
					prev_nodes[0].next = [current_nodes[0]]
					prev_nodes[1].next = [current_nodes[1]]
				else:
					prev_nodes[0].next = current_nodes
					prev_nodes[1].next = current_nodes
		
		nodes.append_array(current_nodes)
		number += 1
		prev_nodes = current_nodes
	
	mapnode_panel.custom_minimum_size.x = 850 + 300 * number
	mapnode_panel.custom_minimum_size.y = 600
	mapnode_panel.visible = true
	
	number -= 1
	for i in len(current_nodes):
		current_nodes[i].generate(4, floor, number)
		if len(current_nodes) == 2:
			match i:
				0:
					current_nodes[i].position.y -= 150
				1:
					current_nodes[i].position.y += 150
		
	
	# for i in nodes:
	#	print("Floor %s, Node %s %s : %s -> %s" % [i.floor_position, i.map_position, i, i.event_name, i.next])
func hide_map_only():
	scroll_container.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	scroll_container.visible = false

func show_map_only():
	scroll_container.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_PASS])
	scroll_container.visible = true


func hide_map():
	self.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	self.visible = false

func show_map():
	self.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_PASS])
	self.visible = true

func move_player(selected_mapnode : MapNode):
	if selected_mapnode in current_position.next:
		current_position = selected_mapnode
		current_position.print_info()
		
		if current_position.event == MapNode.TYPE.COMBAT:
			SignalManager.enter_combat.emit(current_position)
	else:
		print("Illegal move")
