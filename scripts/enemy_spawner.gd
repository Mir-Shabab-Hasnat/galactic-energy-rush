extends Node
@export var MetalBlock_scene = preload("res://scenes/MetalBlock.tscn")
@export var evil_eye_scene = preload("res://scenes/evil_eye.tscn")
@export var floatingPlatform_scene = preload("res://scenes/floating_platform.tscn")
@export var attackingEnemy_scene = preload("res://scenes/attcking_enemy.tscn") # Preload the new scene
@export var attackingEnemyVertical_scene = preload("res://scenes/att_enemy_vertical.tscn")
@export var spawn_interval: float = randf_range(1.5,3.5)
@export var spawn_interval_enemy: float = randf_range(6,15)
@onready var game_instance = get_node("/root/Game")

var start_spawn = false
var timer = 0.0
var enemy_timer := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_spawn:
		# Update timers
		timer += delta
		enemy_timer += delta

		# Spawn general objects at their respective interval
		if timer >= spawn_interval:
			spawn()
			spawnBox()
			#spawnFloatingplatform()      
			timer = 0.0
			spawn_interval = randf_range(1.5, 3.5)  # Optionally randomize the next interval for variety
			spawnAttackingEnemy_vertical()

		# Spawn enemies at their respective interval
		if enemy_timer >= spawn_interval_enemy:
			spawnAttackingEnemy()
			enemy_timer = 0.0
			spawn_interval_enemy = randf_range(6.0, 15.0)  # Optionally randomize the next interval for variety

func spawn() -> void:
	var evil_eye = evil_eye_scene.instantiate()
	
	add_child(evil_eye)
	evil_eye.connect("player_collided", Callable(game_instance, "_on_player_collided"))
	evil_eye.can_move = true
	evil_eye.global_position.x = 630
	evil_eye.global_position.y = 200
	evil_eye.scale = Vector2(0.4, 0.4)
	
	
	
	
func spawnBox() -> void:
	
	var MetalBox= MetalBlock_scene.instantiate()
	add_child(MetalBox)
	var height = randf_range(0.5,1.5)
	
	MetalBox.scale = Vector2(0.5, height)
	MetalBox.global_position.x = 640
	MetalBox.global_position.y = 220
	
	# print(MetalBox.global_position.x, " ",MetalBox.global_position.y)

func spawnFloatingplatform() -> void:
	
	var flPlatform = floatingPlatform_scene.instantiate()
	add_child(flPlatform)
	var height = randf_range(150,200)
	
	
	flPlatform.global_position.x = 500
	flPlatform.global_position.y = height
	
	# print(flPlatform.global_position.x, " ",flPlatform.global_position.y)
# Function to spawn AttackingEnemy
func spawnAttackingEnemy() -> void:
	var attacking_enemy = attackingEnemy_scene.instantiate()
	add_child(attacking_enemy)

	# Set initial properties for the AttackingEnemy
	attacking_enemy.global_position.x = randf_range(500, 600) # Set a random X position within a certain range
	attacking_enemy.global_position.y = -50  # Start off the screen, so it comes down to the visible area

	# Optionally scale or customize the AttackingEnemy properties
	attacking_enemy.scale = Vector2(0.5, 0.5)

func spawnAttackingEnemy_vertical() -> void:
	var attacking_enemy = attackingEnemyVertical_scene.instantiate()
	add_child(attacking_enemy)
	attacking_enemy.scale = Vector2(0.8, 0.8)
	# Set initial properties for the AttackingEnemy
	attacking_enemy.global_position.x = randf_range(600, 800) # Set a random X position within a certain range
	attacking_enemy.global_position.y = randf_range(200, 300)  # Start off the screen, so it comes down to the visible area

	
