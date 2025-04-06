extends Node2D

var player : Player
var player_actions : Array[ActionInstance]
var enemy : Entity

var battle_ongoing : bool = false

enum TURN {PLAYER, ENEMY}

enum STATES {PLANNING, EXECUTION, RESOLUTION, ENEMY}
var current_state : STATES
var state_names = ["Planning", "Execution", "Resolution", "Enemy"]

var current_turn := TURN.PLAYER

func _ready():
	SignalManager.actions_populated.connect(_on_action_board_actions_populated)
	SignalManager.died.connect(entity_death)
	
	SignalManager.orb_swapped.connect(orb_swapped)

func start_battle(player : Entity, enemy : Entity):
	self.player = player
	self.enemy = enemy
	
	battle_ongoing = true
	
	$"../../../DebugButtons/Label5".text = str(player.effective_charge)
	
	# populate enemies with instantiated objects from enemyArray
	# !player.isDead() and len(enemies.get_children()) > 0
	while battle_ongoing:
		match current_turn:
			TURN.PLAYER:
				SignalManager.state_changed.emit(state_names[current_state])
				enemy.decide_action()
				
				# wait until actions are populated
				await SignalManager.player_turn_completed
				print("Player turn ended")
				# end turn
				
				
				SignalManager.regenerate_board.emit()
				
				current_turn = TURN.ENEMY
			TURN.ENEMY:
				current_state = STATES.ENEMY
				SignalManager.state_changed.emit(state_names[current_state])
				
				print("Enemy takes turn")
				enemy.set_target([player])
				enemy.resolve_action(enemy.current_intent)
				
				print("Enemy turn ended")
				# end turn
				current_turn = TURN.PLAYER
				
				SignalManager.full_turn_completed.emit()
	
	print("Battle has ended.")

func _on_action_board_actions_populated(action_array):
	self.player_actions = action_array
	
	# temp target
	player.target = enemy
	
	# resolve Actions
	for i in player_actions:
		player.resolve_action(i)

	SignalManager.player_turn_completed.emit()
	
	$"../../../DebugButtons/Label5".text = str(player.effective_charge)

func orb_swapped(_selectedOrb, _orb):
	current_state = STATES.EXECUTION
	SignalManager.state_changed.emit(state_names[current_state])

func orb_dropped(_orb):
	current_state = STATES.RESOLUTION
	SignalManager.state_changed.emit(state_names[current_state])

func entity_death(entity : Entity):
	if entity == player:
		# trigger game over
		print("Psi has died. Game over.")
	elif entity == enemy:
		print("Enemy has died.")
	
	battle_ongoing = false
