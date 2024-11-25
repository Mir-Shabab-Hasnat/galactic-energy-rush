extends Area2D

@export var bullet_scene = preload("res://scenes/bullet.tscn") # Preload the projectile scene
@onready var game_instance = get_node("/root/Game")

@export var drop_interval: float = 2.0 # Interval in seconds between each projectile drop
@export var projectile_speed: float = 500.0 # Speed of the projectile

@onready var pojectileMark = $projectileMarker # Reference to the Marker2D node to set projectile spawn point

@export var starting_xposition = randf_range(1, 40) # Randomized starting x-position for initial movement
@export var start_point: Vector2 = Vector2(starting_xposition, 20)  # Start point for back-and-forth movement
@export var end_point: Vector2 = Vector2(600, 20) # End point for back-and-forth movement
@export var speed: float = 100.0 # Speed of back-and-forth movement

@export var off_screen_position: Vector2 = Vector2(100, -100) # Off-screen starting position of the enemy
@export var entry_speed: float = 100.0 # Speed for the initial movement onto the screen

var moving_to_end: bool = true # Determines if the enemy is moving towards the end point or the start point
var is_moving_on_screen: bool = true # Indicates if the initial movement onto the screen is in progress
var timer = 0.0 # Timer for projectile drop interval

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set initial position to be off-screen
	position = off_screen_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Initial movement to bring the enemy onto the screen
	if is_moving_on_screen:
		# Calculate direction to move towards the start point from the off-screen position
		var direction = (start_point - position).normalized()
		# Update position based on entry speed
		position += direction * entry_speed * delta

		# Check if we have reached or passed the start point
		if position.distance_to(start_point) <= entry_speed * delta:
			# Snap to the start point and complete the initial movement
			position = start_point
			is_moving_on_screen = false
		return

	# Handle back-and-forth movement between start_point and end_point
	var target = end_point if moving_to_end else start_point

	# Calculate direction vector towards the target point
	var direction = (target - position).normalized()

	# Update position to move towards the target
	position += direction * speed * delta

	# Check if we have reached or passed the target position
	if position.distance_to(target) <= speed * delta:
		# Snap to the target position to avoid small discrepancies
		position = target
		# Switch movement direction to move towards the opposite point
		moving_to_end = not moving_to_end

	# Increment the timer to control the projectile drop interval
	timer += delta

	# Drop a projectile every `drop_interval` seconds
	if timer >= drop_interval:
		shoot()
		# Reset the timer after shooting
		timer = 0.0

# Function to shoot a projectile from the enemy
func shoot() -> void:
	# Instantiate a new bullet
	var bullet = bullet_scene.instantiate()
	# Add bullet to the scene tree as a child of this enemy node
	add_child(bullet)
	# Connect the collision signal to handle player collision
	bullet.connect("player_collided", Callable(game_instance, "_on_player_collided"))

	# Set the bullet's starting position at the position of the `projectileMarker`
	bullet.global_position = pojectileMark.global_position

	# Set downward velocity for the projectile if the bullet has the `set_velocity` method
	if bullet.has_method("set_velocity"):
		bullet.set_velocity(Vector2(0, projectile_speed))

	# print("Projectile dropped!")
