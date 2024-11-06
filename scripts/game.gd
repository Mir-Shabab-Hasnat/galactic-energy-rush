# Main Game Script
extends Node2D

@export var Speed = 300.0
@export var Jump_velocity = -400.0

@onready var player = $Player
@onready var platform = $Platform
@onready var Obstacle = $EvilEye

@onready var ObstacleSpawner = $"Enemy Spawner"
@onready var powerup_manager = $"PowerUpManager"

@onready var healthbar = $HealthBar

@export var energy = 0;
@export var health = 50;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthbar.health = health
	
	# Start the timer when the game is ready
	$Timer.wait_time = 2.0  # Set the wait time to 2 seconds
	$Timer.one_shot = true   # Ensure the timer only runs once
	$Timer.start()           # Start the timer
	
	# Debugging: Print to verify powerup_manager initialization
	print("PowerUpManager: ", powerup_manager)

	# Example of creating and adding a powerup to the scene
	if powerup_manager:
		var powerup = powerup_manager.create_powerup(powerup_manager.PowerUpType.INVINCIBILITY, Vector2(100, 200))
		add_child(powerup)
	else:
		print("Error: PowerUpManager is not initialized")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	_tick_game(delta)

func _tick_game(delta: float) -> void:
	handle_input()
	#set_start_spawn(player.can_move)
	
func handle_input():
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = Jump_velocity
	
	if player.running or player.jump:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			player.velocity.x = direction * Speed
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, Speed)
			
	player.move_and_slide()
	
func set_start_spawn(can_move: bool) -> void:
	if can_move:
		ObstacleSpawner.set_spawn_state(can_move)
	else:
		ObstacleSpawner.set_spawn_state(false)

func _on_timer_timeout() -> void:
	player.can_move = true
	platform.start_scroll = true
	ObstacleSpawner.start_spawn = true
	
	

	
