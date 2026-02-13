class_name PlayerBox
extends CustomControl

@onready var player_character = $PlayerCharacter
@onready var health_bar  = $HealthBar

func load_player(player : Player):
	set_entity_owner(player)
	player_character.texture = player.texture
	health_bar.set_entity_owner(player)
