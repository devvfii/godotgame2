extends TextureProgressBar

@onready var timer = $Timer

var time_passed
var started = false
var last_orb_selected : Orb

func _ready():
	visible = false
	SignalManager.turn_state_changed.connect(_on_turn_state_changed)
	SignalManager.orb_selected.connect(_on_orb_selected)
	SignalManager.orb_dropped.connect(_on_orb_dropped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if visible:
		global_position = get_global_mouse_position()
		global_position.y -= 30
	if timer.get_time_left() > 0:
		time_passed = (timer.wait_time - timer.get_time_left()) / timer.wait_time * 100
		
		value = time_passed

func _on_turn_state_changed(state):
	if state == GlobalConstants.TURN_STATES.EXECUTION and not started:
		started = true
		timer.start()
		visible = true

func _on_orb_selected(orb):
	if not started:
		last_orb_selected = orb

func _on_orb_dropped(_orb):
	timer.stop()
	value = 0
	visible = false
	started = false

func _on_timer_timeout():
	value = 0
	visible = false
	started = false
	SignalManager.turn_state_changed.emit(GlobalConstants.TURN_STATES.RESOLUTION)
	SignalManager.orb_dropped.emit(last_orb_selected)
