extends Node

var player : Entity
var player_actions : Array[ActionInstance]

var enemy : Entity

var battle_ongoing : bool = false

enum TURN {PLAYER, ENEMY}

var turn_state : GlobalConstants.TURN_STATES

var current_turn : TURN = TURN.PLAYER

func _ready():
	SignalManager.board_resolved.connect(_on_board_resolved)
	SignalManager.entity_died.connect(_on_entity_death)
	SignalManager.turn_state_changed.connect(_on_turn_state_changed)
	
	start_battle(null)

func start_battle(enemy : Entity):
	SignalManager.get_player_reference.emit(self)
	self.enemy = enemy
	
	current_turn = TURN.PLAYER
	turn_state = GlobalConstants.TURN_STATES.PLANNING
	player_actions.clear()
	
	battle_ongoing = true
	
	#$"../../../DebugButtons/Label5".text = str(player.effective_charge)
	
	# populate enemies with instantiated objects from enemyArray
	# !player.isDead() and len(enemies.get_children()) > 0
	while battle_ongoing:
		match current_turn:
			TURN.PLAYER:
				SignalManager.turn_state_changed.emit(GlobalConstants.TURN_STATES.PLANNING)
				
				# resolve the board
				while turn_state != GlobalConstants.TURN_STATES.RESOLUTION:
					await get_tree().process_frame
				SignalManager.resolve_board.emit()
				
				# wait until actions are populated
				await SignalManager.actions_populated
				
				# temp target
				player.target = enemy
				# resolve Actions
				for action in player_actions:
					player.resolve_action(action)
				
				SignalManager.regenerate_board.emit()
				SignalManager.debug_log.emit("Player turn ended")
				SignalManager.player_turn_completed.emit()
				current_turn = TURN.ENEMY
			TURN.ENEMY:
				SignalManager.turn_state_changed.emit(GlobalConstants.TURN_STATES.ENEMY)
				
				SignalManager.debug_log.emit("Enemy takes turn")
				enemy.set_target([player])
				enemy.resolve_action(enemy.current_intent)
				
				SignalManager.debug_log.emit("Enemy turn ended")
				SignalManager.enemy_turn_completed.emit()
				SignalManager.full_turn_completed.emit()
				current_turn = TURN.PLAYER
	
	SignalManager.debug_log.emit("Battle has ended.")
	SignalManager.exit_combat.emit(player)

func _on_board_resolved(combos : Array):
	var turn_actions : Array = []
	for action_list in combos:
		var attack_actions : Array = []
		var block_actions : Array = []
		var heal_actions : Array = []
		
		for action in action_list:
			var action_instance = ActionInstance.new(player, player.target, 0, action[0])
			action_instance.orb_count = action[1]
			
			match action_instance.instance_type:
				ActionInstance.TYPE.MATTACK, ActionInstance.TYPE.RATTACK:
					attack_actions.append(action_instance)
				ActionInstance.TYPE.CHARGE:
					player.charge(action_instance.orb_count)
				ActionInstance.TYPE.BLOCK:
					block_actions.append(action_instance)
				ActionInstance.TYPE.HEAL:
					heal_actions.append(action_instance)
			
		turn_actions.append_array(attack_actions)
		turn_actions.append_array(block_actions)
		turn_actions.append_array(heal_actions)
	
	SignalManager.actions_populated.emit(turn_actions)

func _on_entity_death(entity : Entity):
	if entity == player:
		# trigger game over
		SignalManager.debug_log.emit("Psi has died. Game over.")
	elif entity == enemy:
		# temp
		SignalManager.debug_log.emit("Enemy has died.")
	
	battle_ongoing = false

func _on_turn_state_changed(state : GlobalConstants.TURN_STATES) -> void:
	turn_state = state
