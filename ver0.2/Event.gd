extends Control

@onready var dialogue_box = $DialogueLayer/DialogueBox
@onready var name_box = $DialogueLayer/Name
@onready var background_image = $Background/Image
@onready var continue_indicator = $DialogueLayer/ContinueIndicator

@onready var bottom_anchor = $SpriteLayer/BottomAnchor

const event = preload("res://ver0.2/EventData.gd")
var current_event : EventData

var dialogue_actors : Dictionary
var dialogue_lines : Dictionary
var dialogue_script : Array
var dialogue_index : int

func parse_data(current_event : EventData):
	clear_data()
	
	for entry in current_event.event_data:
		match current_event.event_data[entry][0]:
			"Object":
				if Constants.CHARACTERS.has(entry):
					dialogue_actors[entry] = add_character(entry)
			"Text":
				dialogue_lines[entry] = current_event.event_data[entry][1]
	
	for line in current_event.event_script:
		for command in line.split('|'):
			dialogue_script.append(command.strip_edges())
		dialogue_script.append("pause")
	
	print(dialogue_script)
	print(dialogue_actors)

func process_current_line():
	continue_indicator.visible = false
	
	while dialogue_script[dialogue_index] != "pause" and dialogue_index < len(dialogue_script):
		var params = dialogue_script[dialogue_index].split(' ')
		print(params)
		match params[1].to_lower():
			"say":
				name_box.label.text = dialogue_actors[params[0]].character_name
				dialogue_box.change_line(dialogue_lines[params[2]])
			"enter":
				if len(params) == 4:
					dialogue_actors[params[0]].enter(params[2], params[3])
				else:
					dialogue_actors[params[0]].enter(params[2])
			"slide":
				dialogue_actors[params[0]].slide_to(params[2])
			"focus":
				for character in dialogue_actors:
					if character == dialogue_actors[params[0]].character_name:
						dialogue_actors[character].focus()
					else:
						dialogue_actors[character].unfocus()
			"drop":
				dialogue_actors[params[0]].drop()
			"bounce":
				dialogue_actors[params[0]].bounce()
		dialogue_index += 1

func add_character(character_name : String):
	var new_char_box = BigCharacterBox.new_character(character_name)
	bottom_anchor.add_child(new_char_box)
	return new_char_box

func clear_data():
	dialogue_index = 0
	dialogue_lines.clear()
	dialogue_script.clear()
	
	for character in dialogue_actors:
		character.queue_free()
	dialogue_actors.clear()

func _ready():
	current_event = EventData.new()
	current_event.load_test_dummy_data()
	parse_data(current_event)
	
	SignalManager.text_animation_done.connect(_on_text_animation_done)
	continue_indicator.visible = false
	dialogue_index = 0
	process_current_line()

func _input(event):
	if event.is_action_pressed("click") and dialogue_box.is_mouse_inside(get_global_mouse_position()): #or space and inside the box
		if dialogue_box.animate_text:
			dialogue_box.skip_animation()
		else:
			if dialogue_index < len(dialogue_script) - 1:
				dialogue_index += 1
				process_current_line()

func _on_text_animation_done():
	continue_indicator.visible = true
	#character_sprite_box.play_idle_animation()
