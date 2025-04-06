extends CustomControl

func _ready():
	SignalManager.intent_changed.connect(enemy_intent_changed)
	SignalManager.state_changed.connect(change_label3)


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


func enemy_intent_changed(enemy : Enemy):
	$Label6.text = enemy.current_intent.debug_name
	print("%s will %s." % [enemy.entity_name, enemy.current_intent.debug_name])


func _on_button_7_pressed():
	if $"../EnemyBox".entity_owner is Entity:
		$"../EnemyBox".entity_owner.decide_action()


func _on_button_8_pressed():
	SignalManager.debug_breakpoint.emit()

func change_label3(new_text : String):
	$Label3.text = new_text + " Turn"
