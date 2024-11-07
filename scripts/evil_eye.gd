extends Area2D

var can_move = false
var energy = 0
@onready var animated_sprite = $AnimatedSprite2D

@export var speed: float = 200;

var game_instance 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Connect the collision detection signal
	connect("body_entered" ,Callable(self, "_on_body_entered"))
	game_instance = get_node("/root/Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport_rect = get_viewport().get_visible_rect()
	
	update_energy()
	if can_move:
		animated_sprite.play("idle")
		position.x -= (speed + energy) * delta
		
	if global_position.x < viewport_rect.position.x:
		print("eye free at ", position.x)
		queue_free()
	

func _on_body_entered(body):
	if body.is_in_group("player"):  # Assuming obstacles are in an "obstacles" group
		print("Collision with obstacle detected!")
		game_instance.health -= 10
		game_instance.energy -= 10
		queue_free()
		

func update_energy() -> void:
	
	energy = game_instance.energy * 3
