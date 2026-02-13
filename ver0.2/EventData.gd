class_name EventData
extends Resource

var event_name : String
var duplicate_possible : bool

var dependency : String

var event_data : Dictionary
var event_script : Array[Variant]
var event_result : Dictionary

func _init(p_event_name = "dummy", p_duplicate_possible = true, p_dependency = "", p_event_data = {}, p_event_script = [], p_event_result = {}):
	event_name = p_event_name
	duplicate_possible = p_duplicate_possible
	dependency = p_dependency
	event_data = p_event_data
	event_script = p_event_script
	event_result = p_event_result

func load_test_dummy_data():
	event_name = "TestEvent"
	duplicate_possible = false
	dependency = ""
	event_data = {
		"Efi" : ["Object", "Character"],
		"Slime" : ["Object", "Character"],
		"line1" : ["Text", "Testing text animation, display, lorem ipsum dolor sit amet"],
		"line2" : ["Text", "..."],
		"line3" : ["Text", "Alright. Time to die."],
		"line4" : ["Text", "Testing text animation, display, lorem ipsum dolor sit amet"],
		"line5" : ["Text", "5"],
		"line6" : ["Text", "6"],
		"line7" : ["Text", "7"],
		"line8" : ["Text", "8"],
		"line9" : ["Text", "9"],
		"line10" : ["Text", "10"]
	}
	event_script = [
		"Efi enter left 0.5 | Efi say line1 | Efi focus",
		"Efi slide 0.25 | Slime enter right 0.75 | Slime say line2 | Slime focus",
		"Efi say line2 | Efi focus",
		"Efi say line3 | Slime bounce",
		"Slime say line2 | Slime drop | Slime focus"
	]
	event_result = {}

# maybe not for this
func parse_file(file_path : String):
	var file = FileAccess.open(file_path, FileAccess.READ)

	if not file:
		print("Error opening file: ", FileAccess.get_open_error())
		return null
	
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if typeof(data) == TYPE_NIL:
		print("Error parsing JSON: Invalid format")
		return null
	
	
