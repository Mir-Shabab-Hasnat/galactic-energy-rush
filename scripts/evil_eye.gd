extends Area2D

var can_move = false
var energy = 0
@onready var animated_sprite = $AnimatedSprite2D

@export var speed: float = 200;

var game_instance 
signal player_collided(damage)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Connect the collision detection signal
	connect("body_entered", Callable(self, "_on_body_entered"))
	game_instance = get_node("/root/Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport_rect = get_viewport().get_visible_rect()
	update_move_state()
	update_energy()
	if can_move:
		animated_sprite.play("idle")
		position.x -= (speed + energy) * delta
		
	if global_position.x < viewport_rect.position.x:
		# print("eye free at ", position.x)
		queue_free()
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		# print("Emitting player_collided signal with damage: 5")
		emit_signal("player_collided", 5)  # Example damage value
		queue_free()
		

func update_energy() -> void:
	energy = game_instance.player_energy * 3

func update_move_state() -> void:
	can_move = game_instance.start_run
