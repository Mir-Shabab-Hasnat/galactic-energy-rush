extends Area2D

@export var bullet_scene = preload("res://scenes/bullet_vertical.tscn") # Preload the projectile scene
@onready var game_instance = get_node("/root/Game")
@onready var projectile_mark = $Marker2D # Reference to the spawn point for the projectile
@onready var startingxPosition = randf_range(500,600) 
@export var projectile_speed: float = 300.0 # Speed of the projectile
@export var speed: float = 100.0  # Speed for the up-and-down movement
@export var top_point: Vector2 = Vector2(500, 100)  # The top point for vertical movement
@export var bottom_point: Vector2 = Vector2(500, 400)  # The bottom point for vertical movement


var moving_up: bool = false # Indicates direction of vertical movement
var timer: float = 0.0 # Timer for controlling shooting intervals

@export var shoot_interval: float = 2.0 # Time interval between shooting projectiles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the initial position of the enemy to be between top_point and bottom_point
	position = bottom_point
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Update vertical movement between top_point and bottom_point
	var target = top_point if moving_up else bottom_point
	var direction = (target - position).normalized()
	position += direction * speed * delta

	# Check if we have reached or passed the target position
	if position.distance_to(target) <= speed * delta:
		# Snap to the target position to avoid small discrepancies
		position = target
		# Switch direction to move towards the opposite point
		moving_up = not moving_up

	# Increment timer and check if it's time to shoot
	timer += delta
	if timer >= shoot_interval:
		shoot()
		timer = 0.0 # Reset the timer

# Function to shoot a projectile horizontally
func shoot() -> void:
	# Instantiate a new bullet
	var bullet = bullet_scene.instantiate()
	# Add bullet to the scene tree as a child of this enemy node
	add_child(bullet)

	# Connect the collision signal to handle player collision
	bullet.connect("player_collided", Callable(game_instance, "_on_player_collided"))
	bullet.scale = Vector2(0.5, 0.5)
	# Set the bullet's starting position at the position of the `projectileMarker`
	bullet.global_position = projectile_mark.global_position

	# Set horizontal velocity for the projectile if the bullet has the `set_velocity` method
	if bullet.has_method("set_velocity"):
		bullet.set_velocity(Vector2(projectile_speed, 0)) # Set velocity to move leftward

	# Print a message indicating a projectile has been dropped
	print("Horizontal projectile shot!")
