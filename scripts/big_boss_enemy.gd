extends Area2D

@export var bullet_scene = preload("res://scenes/bullet_vertical.tscn")
@onready var game_instance = get_node("/root/Game")
@onready var projectile_mark = $Marker2D
@onready var bullet_sound = $BulletSound
@onready var left_bound = game_instance.get_node("LeftScreenBound")  # Adjust path if needed
@onready var right_bound = game_instance.get_node("RightScreenBounds")  # Adjust path if needed
@export var projectile_speed: float = 500.0
@export var move_speed: float = 200.0
@export var shoot_interval: float = 2.0
@export var vertical_shift_range: Vector2 = Vector2(50, 100)  # Random vertical shift range

var timer: float = 0.0  # Timer for shooting
var direction: Vector2 = Vector2.RIGHT  # Start moving right
var traveling_right: bool = true  # Tracks whether the enemy is moving right
var vertical_target: float = 0.0  # Target Y position for vertical movement
var state: String = "horizontal"  # Movement state: "horizontal" or "vertical"d
var ShotCounter: int = 0

func _ready() -> void:
	$fullCol.disabled = false
	$lowCol.disabled = true

func _process(delta: float) -> void:
	# Handle shooting
	timer += delta
	if timer >= shoot_interval:
		shoot()
		timer = 0.0

	# Handle movement based on state
	if state == "horizontal":
		handle_horizontal_movement(delta)
	elif state == "vertical":
		handle_vertical_movement(delta)

func handle_horizontal_movement(delta: float) -> void:
	# Move horizontally
	var move_step = direction * move_speed * delta
	global_position += move_step

	# Check bounds and adjust to switch to vertical movement
	if traveling_right and global_position.x >= right_bound.global_position.x - 50:
		traveling_right = false
		set_vertical_target(-1)  # Set target to move down
	elif not traveling_right and global_position.x <= left_bound.global_position.x + 50:
		traveling_right = true
		set_vertical_target(1)  # Set target to move up

func handle_vertical_movement(delta: float) -> void:
	# Move vertically towards the target position
	var vertical_step = move_speed * delta * sign(vertical_target - global_position.y)
	global_position.y += vertical_step

	# Check if the enemy has reached the target Y position
	if abs(global_position.y - vertical_target) <= 5:  # Close enough to the target
		state = "horizontal"  # Switch back to horizontal movement
		direction = Vector2.RIGHT if traveling_right else Vector2.LEFT  # Resume horizontal movement

func set_vertical_target(direction_multiplier: int) -> void:
	# Set the vertical target position based on a random shift
	var vertical_shift = randf_range(vertical_shift_range.x, vertical_shift_range.y) * direction_multiplier
	vertical_target = global_position.y + vertical_shift
	state = "vertical"  # Switch to vertical movement

func shoot() -> void:
	# Instantiate a new bullet
	$BulletSound.play()
	var bullet = bullet_scene.instantiate()
	game_instance.add_child(bullet)

	# Connect the collision signal to handle player collision
	bullet.connect("player_collided", Callable(game_instance, "_on_player_collided"))
	bullet.scale = Vector2(1, 0.7)
	# Set the bullet's starting position at the position of the `projectileMarker`
	bullet.global_position = projectile_mark.global_position

	# Get the player's global position
	var player = game_instance.get_node("Player")  # Adjust the path to your player's node
	var player_position = player.global_position

	# Calculate the direction vector from the bullet to the player
	var direction = (player_position - bullet.global_position).normalized()

	# Set the bullet's velocity towards the player
	var velocity = direction * projectile_speed

	# Set the bullet's velocity if the bullet has the `set_velocity` method
	bullet.set_velocity(velocity)

	print("Projectile shot towards player!")







func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		$fullCol.call_deferred("set_disabled", true)
		$lowCol.call_deferred("set_disabled", false)
		ShotCounter +=1
		if ShotCounter ==1:
			$AnimatedSprite2D.play("med")
		elif ShotCounter ==2:
			$AnimatedSprite2D.play("low")
		elif ShotCounter ==3 :
			$AnimatedSprite2D.play("death")
			$AnimatedSprite2D.scale = Vector2(0.5, 0.5)
			$DeathSound.play()
			#resclae cus explosion too big
			await game_instance.get_tree().create_timer(0.42).timeout
			print("enemy shot")
			queue_free()	
