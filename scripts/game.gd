# Main Game Script
extends Node2D

@export var Speed = 300.0
@export var Jump_velocity = -400.0

var main_menu = preload("res://scenes/main_menu.tscn")

@onready var player = $Player
@onready var platform = $Platform
# @onready var Obstacle = $EvilEye



@onready var ObstacleSpawner = $"Enemy Spawner"
@onready var powerup_manager = $"PowerUpManager"

@onready var healthbar = $HealthBar
@onready var energyBar = $EnergyBar
@onready var scoreLabel = $ScoreLabel

@export var energy: int = 0;
var appliedEnergy
@export var health = 20;
var score: int = 0;
var accumulated_score: float = 0.0;
var game_started: bool = false

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
	
	if health <= 0:
		game_end()
	
	if start_run:
		# Increment the accumulated score based on the player's velocity
		accumulated_score += max(5, energy) * delta

		# Update the integer score variable when the accumulated score exceeds 1
		if accumulated_score >= 1.0:
			score += int(accumulated_score)
			accumulated_score -= int(accumulated_score)
		scoreLabel.text = "Score: " + str(int(score))  # Update the score label


	_tick_game(delta)
	
	

func _tick_game(_delta: float) -> void:
	updateGameState()
	
	handle_input()
	
	energyBar.energy = energy
	healthbar.health = health
	
	apply_energy()
	
	
func handle_input():
	if Input.is_action_just_pressed("pause"):
		if start_run:
			start_run = false
		else:
			start_run = true
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
		game_started = true
		powerup_manager.start_spawn = true
	else:
		player.can_move = false
		platform.start_scroll = false
		ObstacleSpawner.start_spawn = false
		powerup_manager.start_spawn = true
		

func game_end()-> void:
	
	if main_menu:
		# Remove the current game scene
		self.queue_free()
		
		# Load and add the main menu scene
		var main_menu_instance = main_menu.instantiate()
   
		get_tree().root.add_child(main_menu_instance)
		print("Loaded main menu scene.")
	else:
		print("Error: main_menu scene is not loaded correctly.")
