# Main Game Script
extends Node2D

@export var Speed = 300.0
@export var Jump_velocity = -400.0

@onready var player = $Player
@onready var platform = $Platform
# @onready var Obstacle = $EvilEye

@onready var ObstacleSpawner = $"Enemy Spawner"
@onready var powerup_manager = $"PowerUpManager"

@onready var healthbar = $HealthBar
@onready var energyBar = $EnergyBar

@export var energy: int = 0;
var appliedEnergy
@export var health = 100;

var start_run = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	healthbar.health = health
	energyBar.energy = energy
	
	# Start the timer when the game is ready
	$Timer.wait_time = 2.0  # Set the wait time to 2 seconds
	$Timer.one_shot = true   # Ensure the timer only runs once
	$Timer.start()           # Start the timer

	powerup_manager.start_spawn = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health > 100:
		health = 100
	if energy > 100:
		energy = 100
	_tick_game(delta)
	
	

func _tick_game(_delta: float) -> void:
	updateGameState()
	
	handle_input()
	
	energyBar.energy = energy
	healthbar.health = health
	
	apply_energy()
	
	
func handle_input():
	if Input.is_action_just_pressed("pause"):
		start_run = false
		print("trying to pause the game")
		print(start_run)
	if start_run:
		if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
			player.velocity.y = Jump_velocity
		
		if player.running or player.jump:
			var direction := Input.get_axis("ui_left", "ui_right")
			if direction:
				player.velocity.x = direction * (Speed + energy)
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, (Speed + energy))
			
	player.move_and_slide()

func apply_energy():
	appliedEnergy = energy * 2
	platform.energy = appliedEnergy
	
	
func _on_timer_timeout() -> void:
	start_run = true
	
	
func updateGameState() -> void:
	if start_run:
		player.can_move = true
		platform.start_scroll = true
		ObstacleSpawner.start_spawn = true
		powerup_manager.start_spawn = true
	else:
		player.can_move = false
		platform.start_scroll = false
		ObstacleSpawner.start_spawn = false
		powerup_manager.start_spawn = true
		

	
