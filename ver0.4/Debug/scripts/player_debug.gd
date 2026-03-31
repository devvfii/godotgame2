extends Control

@onready var player_reference_label = $PlayerReference

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if player:
		player_reference_label.text = str(player)

func _on_get_player_reference_pressed():
	SignalManager.get_player_reference.emit(self)
