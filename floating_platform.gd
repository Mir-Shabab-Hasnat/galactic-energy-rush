extends RigidBody2D

var speed: float = 170  # Adjust speed as desired

func _ready() -> void:
	gravity_scale = 0  # Disable gravity for this body

# Called every physics frame
func _physics_process(delta: float) -> void:
	# Continuously set the linear velocity to move left at a constant speed
	
	linear_velocity = Vector2(-speed, 0)

# Optional: Handle cleanup when the object moves off-screen
func _process(delta: float) -> void:
	var viewport_rect = get_viewport().get_visible_rect()
	if global_position.x < viewport_rect.position.x -100:
		print("platform free at ", position.x)
		queue_free()
