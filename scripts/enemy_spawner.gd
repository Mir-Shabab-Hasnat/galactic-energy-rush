extends Node

@export var MetalBlock_scene = preload("res://scenes/MetalBlock.tscn")
@export var evil_eye_scene = preload("res://scenes/evil_eye.tscn")
@export var floatingPlatform_scene = preload("res://scenes/floating_platform.tscn")
@export var attackingEnemy_scene = preload("res://scenes/attcking_enemy.tscn")  # Preload the new scene
@export var attackingEnemyVertical_scene = preload("res://scenes/att_enemy_vertical.tscn")

@onready var game_instance = get_node("/root/Game")

var start_spawn = false

# General spawning variables (spawn() and spawnBox())
var timer_general = 0.0
var spawn_interval_general = randf_range(1.3, 3.0)  # Random interval between 1.3 and 3 seconds

# Attacking enemy spawning variables (spawnAttackingEnemy())
var timer_attacking_enemy_delay = 0.0
var start_delay_attacking_enemy = randf_range(25.0, 50.0)  # Initial delay between 1.5 and 2.3 minutes
var can_spawn_attacking_enemy = false
var timer_attacking_enemy_spawn = 0.0
var spawn_interval_attacking_enemy = randf_range(6.0, 12.0)  # Spawn interval between 7 and 15 seconds

# Vertical attacking enemy spawning variables (spawnAttackingEnemy_vertical())
var timer_attacking_enemy_vertical_delay = 0.0
var start_delay_attacking_enemy_vertical = randf_range(30.0,60.0)  # Initial delay between 2.5 and 3 minutes
var can_spawn_attacking_enemy_vertical = false
var timer_attacking_enemy_vertical_spawn = 0.0
var spawn_interval_attacking_enemy_vertical = randf_range(7.0, 10.0)  # Spawn interval between 10 and 20 seconds

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if start_spawn:
		# General Spawning (spawn() and spawnBox())
		timer_general += delta
		if timer_general >= spawn_interval_general:
			spawn()
			spawnBox()
			timer_general = 0.0
			spawn_interval_general = randf_range(1.3, 3.0)  # Randomize the next interval

		# Attacking Enemy Spawning (spawnAttackingEnemy())
		if not can_spawn_attacking_enemy:
			# Waiting for the initial delay to pass
			timer_attacking_enemy_delay += delta
			if timer_attacking_enemy_delay >= start_delay_attacking_enemy:
				can_spawn_attacking_enemy = true
				timer_attacking_enemy_spawn = 0.0  # Reset spawn timer
		else:
			timer_attacking_enemy_spawn += delta
			if timer_attacking_enemy_spawn >= spawn_interval_attacking_enemy:
				spawnAttackingEnemy()
				timer_attacking_enemy_spawn = 0.0
				spawn_interval_attacking_enemy = randf_range(7.0, 15.0)  # Randomize the next interval

		# Vertical Attacking Enemy Spawning (spawnAttackingEnemy_vertical())
		if not can_spawn_attacking_enemy_vertical:
			# Waiting for the initial delay to pass
			timer_attacking_enemy_vertical_delay += delta
			if timer_attacking_enemy_vertical_delay >= start_delay_attacking_enemy_vertical:
				can_spawn_attacking_enemy_vertical = true
				timer_attacking_enemy_vertical_spawn = 0.0  # Reset spawn timer
		else:
			timer_attacking_enemy_vertical_spawn += delta
			if timer_attacking_enemy_vertical_spawn >= spawn_interval_attacking_enemy_vertical:
				spawnAttackingEnemy_vertical()
				timer_attacking_enemy_vertical_spawn = 0.0
				spawn_interval_attacking_enemy_vertical = randf_range(10.0, 20.0)  # Randomize the next interval

func spawn() -> void:
	var evil_eye = evil_eye_scene.instantiate()
	add_child(evil_eye)
	evil_eye.connect("player_collided", Callable(game_instance, "_on_player_collided"))
	evil_eye.can_move = true
	evil_eye.global_position.x = 630
	evil_eye.global_position.y = randf_range(150,230)
	var scale_size = randf_range(0.1,0.6)
	evil_eye.scale = Vector2(scale_size, scale_size)

func spawnBox() -> void:
	var MetalBox = MetalBlock_scene.instantiate()
	add_child(MetalBox)
	var height = randf_range(0.5, 1.5)
	MetalBox.scale = Vector2(0.5, height)
	MetalBox.global_position.x = 640
	MetalBox.global_position.y = 220

func spawnFloatingplatform() -> void:
	var flPlatform = floatingPlatform_scene.instantiate()
	add_child(flPlatform)
	var height = randf_range(150, 200)
	flPlatform.global_position.x = 500
	flPlatform.global_position.y = height

func spawnAttackingEnemy() -> void:
	var attacking_enemy = attackingEnemy_scene.instantiate()
	add_child(attacking_enemy)
	attacking_enemy.global_position.x = randf_range(500, 600)  # Random X position
	attacking_enemy.global_position.y = -50  # Start off-screen
	attacking_enemy.scale = Vector2(0.5, 0.5)

func spawnAttackingEnemy_vertical() -> void:
	var attacking_enemy = attackingEnemyVertical_scene.instantiate()
	add_child(attacking_enemy)
	attacking_enemy.scale = Vector2(0.8, 0.8)
	attacking_enemy.global_position.x = randf_range(600, 800)  # Random X position
	attacking_enemy.global_position.y = randf_range(200, 300)  # Random Y position
