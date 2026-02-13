extends CustomControl

@onready var player_box = $PlayerBox
@onready var enemy_box = $EnemyBox
@onready var battle_elements = $BattleElements

@onready var action_board = $BattleElements/Board/ActionBoard
@onready var turn_manager = $BattleElements/Board/TurnManager

func start_battle(player : Player, enemy : Enemy):
	player_box.load_player(player)
	enemy_box.load_enemy(enemy)
	
	action_board.clearBoard()
	action_board.regenerateBoard()
	turn_manager.start_battle(player, enemy)
	
	show_battle()

func hide_battle():
	self.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	self.visible = false

func show_battle():
	self.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_PASS])
	self.visible = true
