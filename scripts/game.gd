# Main Game Script
extends Node2D

@export var Speed = 300.0
@export var Jump_velocity = -400.0

var main_menu = preload("res://scenes/main_menu.tscn")
var game_reload = preload("res://scenes/game.tscn")
@onready var game_over = preload("res://scenes/game_over_menu.tscn").instantiate()

@onready var player = $Player
@onready var platform = $Platform
#@onready var enemy = $EvilEye

@onready var ObstacleSpawner = $"Enemy Spawner"
@onready var powerup_manager = $"PowerUpManager"

@onready var energyBar = $EnergyBar
@onready var scoreLabel = $ScoreLabel

@onready var leftBoundary = $LeftScreenBound
var appliedEnergy # whats the point of this
var player_energy
var score: int = 0;
var accumulated_score: float = 0.0;
var game_started: bool = false
var start_run = false
var elapsed_time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	energyBar.energy = player.energy
	
	# Start the timer when the game is ready
	$Timer.wait_time = 2.0  # Set the wait time to 2 seconds
	$Timer.one_shot = true   # Ensure the timer only runs once
	$Timer.start()           # Start the timer

	powerup_manager.start_spawn = true
	
	add_child(game_over)
	game_over.visible = false
	game_over.connect("restart_game",Callable( self, "_on_restart_game"))
	game_over.connect("exit_game", Callable(self, "_on_exit_game"))
	
	if leftBoundary:
		leftBoundary.connect("body_entered", Callable(self, "_on_left_boundary_entered"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	if player.energy > 100:
		player.energy = 100
		player_energy = player.energy
	
	if player.energy <= 0:
		await get_tree().create_timer(0.1).timeout
		_game_end()
	
	if start_run:
		# Increment the accumulated score based on the player's velocity
		accumulated_score += max(5, player.energy) * delta

		# Update the integer score variable when the accumulated score exceeds 1
		if accumulated_score >= 1.0:
			score += int(accumulated_score)
			accumulated_score -= int(accumulated_score)
		scoreLabel.text = "Score: " + str(int(score))  # Update the score label

	_check_if_player_off_screen()
	_tick_game(delta)
	
	

func _tick_game(_delta: float) -> void:
	updateGameState()
	
	handle_input()
	
	energyBar.energy = player.energy
	player_energy = player.energy
	
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
				player.velocity.x = direction * (Speed + player.energy)
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, (Speed + player.energy))
			
	player.move_and_slide()

func _on_player_collided(energy_loss):
	if not player.is_invincible:
		player.decrement_energy(energy_loss)
		player.energy -= energy_loss
		player_energy = player.energy
		energyBar.energy = player.energy  # Update energy bar with player's energy


# What does this function do?
func apply_energy():
	appliedEnergy = player.energy * 2
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
		

func _game_end():

	get_tree().paused = true
	
	game_over.global_position.x = 0
	game_over.global_position.y = 0
	
	game_over.scale = Vector2(0.5,0.5)
	
	game_over.visible = true

func _on_restart_game():
	print("Restarting game...")

	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_game():
	print("exiting game")
	get_tree().quit()
	
# Function called when player hits the left boundary
func _on_left_boundary_entered(body):
	if body.is_in_group("player"):
		print("Player hit the left boundary, taking 10 damage")
		_on_player_collided(10)  # Player takes 10 damage when hitting the left boundary
func _check_if_player_off_screen():
	if player.global_position.x < leftBoundary.global_position.x:
		_on_player_collided(10*((leftBoundary.global_position.x-player.global_position.x)/1000))
