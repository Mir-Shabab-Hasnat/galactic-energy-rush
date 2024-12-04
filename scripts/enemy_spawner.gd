extends Node

@export var MetalBlock_scene = preload("res://scenes/MetalBlock.tscn")
@export var evil_eye_scene = preload("res://scenes/evil_eye.tscn")
@export var floatingPlatform_scene = preload("res://scenes/floating_platform.tscn")
@export var attackingEnemy_scene = preload("res://scenes/attcking_enemy.tscn")  # Preload the new scene
@export var attackingEnemyVertical_scene = preload("res://scenes/att_enemy_vertical.tscn")
@export var BigBossEnemy = preload("res://scenes/big_boss_Enemy.tscn")

@onready var game_instance = get_node("/root/Game")

var start_spawn = false


# General spawning variables (spawn() and spawnBox())
var timer_general = 0.0
var spawn_interval_general = 3.0  # Initial interval
var min_spawn_interval_general = 1.3  # Minimum interval
var max_spawn_interval_general = 3.0  # Maximum interval
var general_spawn_count = 1  # Number of enemies to spawn
var max_general_spawns = 5  # Maximum spawns per cycle


var spawn_interval_general_box = randf_range(4,6)
var min_box_interval = 4.0
var max_spawn_box_interv = 9.0
var timer_general_box = 0.0


# Attacking enemy spawning variables (spawnAttackingEnemy())
var timer_attacking_enemy_spawn = 0.0
var spawn_interval_attacking_enemy = 15.0  # Initial interval
var min_spawn_interval_attacking_enemy = 4.0  # Minimum interval
var max_spawn_interval_attacking_enemy = 12.0  # Maximum interval
var attacking_enemy_spawn_count = 1
var max_attacking_enemy_spawns = 5

# Vertical attacking enemy spawning variables (spawnAttackingEnemy_vertical())
var timer_attacking_enemy_vertical_spawn = 0.0
var spawn_interval_attacking_enemy_vertical = 45.0  # Initial interval
var min_spawn_interval_attacking_enemy_vertical = 5.0
var max_spawn_interval_attacking_enemy_vertical = 10.0
var attacking_enemy_vertical_spawn_count = 1
var max_attacking_enemy_vertical_spawns = 5


# Big Boss Enemy spawning variables (spawnBigBoss())
var timer_big_boss_spawn = 0.0
var spawn_interval_big_boss = 60.0  # Initial spawn interval
var big_boss_spawn_count = 1  # Number of Big Bosses to spawn
var max_big_boss_spawns = 5  # Maximum number of spawns per cycle
var min_spawn_interval_big_boss = 20.0  # Minimum interval

var game_time: float = 0.0  #keeps track of how long game has been going

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	game_time += delta 
	
	if start_spawn:
		# General Spawning
		timer_general += delta
		if timer_general >= spawn_interval_general:
			for i in range(general_spawn_count):
				spawn()
<<<<<<< HEAD
				
				
=======
				spawnBox()
>>>>>>> 826d9d8b09fc5c9fb69af8850d13c76fa7ff8d55
			timer_general = 0.0
			spawn_interval_general = max(spawn_interval_general - 0.2, min_spawn_interval_general)
			general_spawn_count = 1
			
		timer_general_box += delta
		if timer_general_box>= spawn_interval_general_box:
			for i in range(general_spawn_count):
				
				spawnBox()
				
			timer_general_box = 0.0
			spawn_interval_general_box = max(spawn_interval_general_box - 0.2, min_box_interval )
			general_spawn_count = 1

		# Attacking Enemy Spawning
		timer_attacking_enemy_spawn += delta
		if timer_attacking_enemy_spawn >= spawn_interval_attacking_enemy:
			for i in range(attacking_enemy_spawn_count):
				spawnAttackingEnemy()
			timer_attacking_enemy_spawn = 0.0
			spawn_interval_attacking_enemy = max(spawn_interval_attacking_enemy - 1.0, min_spawn_interval_attacking_enemy)
			if spawn_interval_attacking_enemy == min_spawn_interval_attacking_enemy:
				attacking_enemy_spawn_count = randi_range(1,2)
			else:
				
				attacking_enemy_spawn_count =1

		# Vertical Attacking Enemy Spawning
		timer_attacking_enemy_vertical_spawn += delta
		if timer_attacking_enemy_vertical_spawn >= spawn_interval_attacking_enemy_vertical:
			for i in range(attacking_enemy_vertical_spawn_count):
				spawnAttackingEnemy_vertical()
			timer_attacking_enemy_vertical_spawn = 0.0
			spawn_interval_attacking_enemy_vertical = max(spawn_interval_attacking_enemy_vertical - 10, min_spawn_interval_attacking_enemy_vertical)
			if spawn_interval_attacking_enemy_vertical == min_spawn_interval_attacking_enemy_vertical:
				attacking_enemy_vertical_spawn_count = randi_range(1,2)
			else:
				attacking_enemy_vertical_spawn_count = 1
		# Big Boss Enemy Spawning
		timer_big_boss_spawn += delta
		if timer_big_boss_spawn >= spawn_interval_big_boss:
			spawnBigBoss()
			timer_big_boss_spawn = 0.0
			spawn_interval_big_boss = max(spawn_interval_big_boss - 10.0, min_spawn_interval_big_boss)
			big_boss_spawn_count = min(big_boss_spawn_count + 1, max_big_boss_spawns)




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
	
	# Assuming MetalBox has a CollisionShape2D or Sprite child named "CollisionShape2D"
	var collision_shape = MetalBox.get_node("CollisionShape2D")
	var shape = collision_shape.shape
	var original_height = shape.extents.y * 2
	
	var base_y_position = 230 if randi() % 2 == 0 else 200
	MetalBox.global_position.y = base_y_position - (original_height * (height - 1)/ 2)

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

	# Calculate scale based on game time
	var initial_scale = 1.5  # Starting scale (largest)
	var min_scale = 0.5  # Minimum scale (smallest it can shrink to)
	var shrink_rate = 30.0  # Shrinks every 30 seconds
	var scale_factor = max(initial_scale - (game_time / shrink_rate * 0.2), min_scale)

	attacking_enemy.scale = Vector2(scale_factor, scale_factor)

	# Randomize position
	attacking_enemy.global_position.x = randf_range(600, 800)  # Random X position
	attacking_enemy.global_position.y = randf_range(200, 300)  # Random Y position

func spawnBigBoss() -> void:
	var BigBoss = BigBossEnemy.instantiate()
	add_child(BigBoss)
	BigBoss.scale = Vector2(0.8, 0.8)
	BigBoss.global_position.x = randf_range(600, 800)  # Random X position
	BigBoss.global_position.y = randf_range(150,200)  # Random Y position
