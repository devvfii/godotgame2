extends Control

@onready var turn_state_label = $TurnState
@onready var combos_label = $Combos

func _ready():
	SignalManager.turn_state_changed.connect(_on_turn_state_changed)
	SignalManager.board_resolved.connect(_on_board_resolved)
	
	SignalManager.debug_log.connect(_on_debug_log)
	SignalManager.disable_debug_ui.connect(_on_disable_debug_ui)
	SignalManager.enable_debug_ui.connect(_on_enable_debug_ui)

func _on_board_resolved(combos : Array):
	combos_label.text += str(combos) + "\n"

func _on_clear_board_pressed():
	SignalManager.clear_board.emit()

func _on_debug_log(log_message : String):
	print(log_message)

func _on_disable_debug_ui():
	visible = false

func _on_enable_debug_ui():
	visible = true

func _on_regenerate_board_pressed():
	SignalManager.regenerate_board.emit()

func _on_resolve_board_pressed():
	SignalManager.resolve_board.emit()

func _on_turn_state_changed(new_state : GlobalConstants.TURN_STATES):
	turn_state_label.text = GlobalConstants.TURN_STATES.keys()[new_state]
	


func _on_resize_board_pressed() -> void:
	SignalManager.resize_board.emit(GlobalConstants.SCREEN_RESOLUTIONS_MAP[DisplayServer.screen_get_usable_rect().size])


func _on_start_battle_pressed() -> void:
	SignalManager.enter_combat.emit(null)
