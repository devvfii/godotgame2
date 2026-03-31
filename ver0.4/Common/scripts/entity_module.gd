extends Control

@onready var entity = $Entity
@onready var health_bar = $HealthBar

const MAX_HEALTH_BAR_HEIGHT = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	var entity_size = entity.texture.get_size()
	entity.position.y -= entity_size.y / 2.0

	health_bar.custom_minimum_size = Vector2(entity_size.x, MAX_HEALTH_BAR_HEIGHT)
	health_bar.position.y += MAX_HEALTH_BAR_HEIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
