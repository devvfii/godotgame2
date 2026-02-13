extends PanelContainer

@onready var label = $RichTextLabel

const ANIMATION_SPEED : int = 60

var animate_text : bool = false
var current_visible_characters : int = 0

var control_rect : Rect2

func change_line(line : String):
	current_visible_characters = 0
	label.visible_characters = 0
	label.text = line
	animate_text = true

func skip_animation():
	label.visible_ratio = 1

func _process(delta):
	if animate_text:
		if label.visible_ratio < 1:
			label.visible_ratio += (1.0/label.text.length()) * (ANIMATION_SPEED * delta)
			current_visible_characters = label.visible_characters
		else:
			animate_text = false
			SignalManager.text_animation_done.emit()

func is_mouse_inside(mouse_position : Vector2):
	control_rect = get_global_rect()
	return control_rect.has_point(mouse_position)
