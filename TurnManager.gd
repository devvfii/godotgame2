extends Node2D

var player : Player
var player_actions : Array[ActionInstance]
var enemy : Entity

enum TURN {PLAYER, ENEMY}

var current_turn := TURN.PLAYER

func _ready():
	SignalManager.actions_populated.connect(_on_action_board_actions_populated)

func start_battle(player : Entity, enemy : Entity):
	self.player = player
	self.enemy = enemy
	
	# populate enemies with instantiated objects from enemyArray
	# !player.isDead() and len(enemies.get_children()) > 0
	while(true):
		match current_turn:
			TURN.PLAYER:
				$"../../../DebugButtons/Label3".text = "Player Turn"
				# wait until actions are populated
				await SignalManager.player_turn_completed
				# end turn
				self.current_turn = TURN.ENEMY
			TURN.ENEMY:
				$"../../../DebugButtons/Label3".text = "Enemy Turn"
				print("Enemy takes turn")
				# end turn
				self.current_turn = TURN.PLAYER

func _on_action_board_actions_populated(action_array):
	self.player_actions = action_array
	
	# temp target
	player.target = enemy
	
	# resolve Actions
	for i in player_actions:
		player.resolve_action(i)

	SignalManager.player_turn_completed.emit()
