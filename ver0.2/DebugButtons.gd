extends CustomControl


func _on_button_pressed():
	if $"../PlayerBox".entity_owner is Entity:
		$"../PlayerBox".entity_owner.takeDamage(10)

func _on_button_2_pressed():
	if $"../EnemyBox".entity_owner is Entity:
		$"../EnemyBox".entity_owner.takeDamage(10)

func _on_button_3_pressed():
	$"../BattleElements/Board/ActionBoard".regenerateBoard()

func _on_button_4_pressed():
	$"../BattleElements/Board/ActionBoard".resolveBoard()

func _on_button_5_pressed():
	$"../BattleElements/Board/ActionBoard".clearBoard()


func _on_button_6_pressed():
	$"../BattleElements/Board/TurnManager".start_battle($"../PlayerBox".entity_owner,$"../EnemyBox".entity_owner)
