extends TextureProgressBar
@onready var timer = $TurnTimer


var time_passed
var started = false
var last_orb_selected : Orb_old

func _ready():
	self.visible = false
	SignalManager.state_changed.connect(_on_state_change)
	SignalManager.orb_selected.connect(_on_orb_selected)
	SignalManager.orb_dropped.connect(_on_orb_dropped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if visible:
		global_position = get_global_mouse_position()
		global_position.y -= 30
	if timer.get_time_left() > 0:
		time_passed = (timer.wait_time - timer.get_time_left()) / timer.wait_time * 100
		
		self.value = time_passed

func _on_state_change(state):
	if state == "Execution" and not started:
		started = true
		timer.start()
		self.visible = true
	
func _on_turn_timer_timeout():
	self.value = 0
	self.visible = false
	started = false
	SignalManager.orb_dropped.emit(last_orb_selected)

func _on_orb_selected(orb):
	if not started:
		last_orb_selected = orb

func _on_orb_dropped(_orb):
	timer.stop()
	self.value = 0
	self.visible = false
	started = false
	
