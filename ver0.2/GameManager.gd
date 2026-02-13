extends CustomControl

@onready var map_module = $Map
@onready var battle_module = $Battle

var player : Player

var temp_enemy : Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.enter_combat.connect(start_battle)
	SignalManager.exit_combat.connect(end_battle)
	
	player = Player.new("Psi")
	add_child(player)
	
	new_temp_enemy()

func start_battle(_mapnode : MapNode):
	await get_tree().create_timer(0.5).timeout
	map_module.hide_map()
	battle_module.start_battle(player,temp_enemy)


func end_battle(_player : Player):
	await get_tree().create_timer(0.5).timeout
	battle_module.hide_battle()
	map_module.show_map()
	
	new_temp_enemy()

func new_temp_enemy():
	temp_enemy = Slime_Boss.new("Slime Boss", "res://tempassets/enemy.png")
	
	add_child(temp_enemy)
