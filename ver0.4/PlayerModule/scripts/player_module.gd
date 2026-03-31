extends Control

@onready var player_marker = $PlayerMarker
@onready var player = $Player

func _ready():
	SignalManager.get_player_reference.connect(_on_get_player_reference)

func _on_get_player_reference(node : Node):
	if "player" in node:
		node.player = player
