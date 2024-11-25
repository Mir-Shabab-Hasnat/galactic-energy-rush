extends Area2D
var speed = 400

var energy = 0

var game_instance

var direction = Vector2.ZERO 

func _ready() -> void:
	game_instance = get_node("/root/Game")

func _process(delta: float) -> void:
	position += direction * (speed + energy) * delta
	update_energy()
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func update_energy() -> void:
	energy = game_instance.player_energy * 3
