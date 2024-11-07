extends RigidBody2D

var energy = 0
var speed: float = 125
var game_instance 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	game_instance = get_node("/root/Game")
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_energy()
	var viewport_rect = get_viewport().get_visible_rect()
	if global_position.x < viewport_rect.position.x:
		print("metal free at ", position.x)
		queue_free()
	pass


func _physics_process(delta: float) -> void:
# Apply a force to the right (increase x component to increase speed)
	position.x -= (speed + energy) * delta  # Move the body right at 100 pixels per second
	
func update_energy() -> void:
	
	energy = game_instance.energy * 3
