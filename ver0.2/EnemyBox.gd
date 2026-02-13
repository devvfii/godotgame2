class_name EnemyBox
extends CustomControl

@onready var enemy_character = $Enemy
@onready var health_bar  = $HealthBar

func load_enemy(enemy : Enemy):
	set_entity_owner(enemy)
	enemy_character.texture = enemy.texture
	health_bar.set_entity_owner(enemy)
	health_bar.update_hp(enemy)
