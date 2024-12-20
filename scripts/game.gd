# Main Game Script
extends Node2D

@export var Speed = 300.0
@export var Jump_velocity = -400.0

var main_menu = preload("res://scenes/main_menu.tscn")
var game_reload = preload("res://scenes/game.tscn")
@onready var game_over = preload("res://scenes/game_over_menu.tscn").instantiate()
@onready var game_paused = preload("res://scenes/pause_menu.tscn").instantiate()
@onready var game_instruction_Display = preload("res://scenes/GameInstructions.tscn").instantiate()

@onready var player = $Player
@onready var platform = $Platform
#@onready var enemy = $EvilEye

@onready var ObstacleSpawner = $"Enemy Spawner"
@onready var powerup_manager = $"PowerUpManager"

@onready var energyBar = $EnergyBar
@onready var scoreLabel = $ScoreLabel
@onready var timeLabel = $TimeLabel
@onready var ammoLabel = $Ammunition

@onready var leftBoundary = $LeftScreenBound

@onready var background = $Backgrounf
@onready var camera = $Camera2D

var appliedEnergy # whats the point of this
var player_energy
var score: int = 0;
var accumulated_score: float = 0.0;
var game_started: bool = false
var game_ended: bool = false
var start_run = false
var elapsed_time: float = 0.0
var shoot_timer = 0.0

var InstrutionTimer = 0.0
var ammo = 0;
var capacity = 50;

enum PowerUpType { SHIELD, INVINCIBILITY, ENERGY_PICKUP }

var top_scores = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.modulate = Color(0.5, 0.2, 0.8, 1)
	
	# print("SceneTree available:", get_tree())
	
	
	load_scores()  # Load the top scores when the game starts
	energyBar.energy = player.energy
	ammoLabel.ammo = player.ammo
	scoreLabel.modulate = Color(1, 1, 1)  # Set the score label color to white
	
	# Start the timer when the game is ready
	$Timer.wait_time = 2.0  # Set the wait time to 2 seconds
	$Timer.one_shot = true   # Ensure the timer only runs once
	$Timer.start()           # Start the timer

	powerup_manager.start_spawn = true
	
	add_child(game_instruction_Display)
	game_instruction_Display.scale = Vector2(3.5, 3.5)
	game_instruction_Display.global_position.x = 250
	game_instruction_Display.global_position.y = 50
	game_instruction_Display.visible = true
	
	
	

	
	#for game over menu
	add_child(game_over)
	game_over.visible = false
	game_over.connect("restart_game",Callable( self, "_on_restart_game"))
	game_over.connect("exit_game", Callable(self, "_on_exit_game"))
	
	add_child(game_paused)
	game_paused.visible = false
	game_paused.connect("restart_game",Callable( self, "_on_restart_game"))
	game_paused.connect("exit_game", Callable(self, "_on_exit_game"))
	game_paused.connect("resume_game", Callable(self, "_on_resume_game"))
	
	#detects if objects have colided with left boundary
	if leftBoundary:
		leftBoundary.connect("body_entered", Callable(self, "_on_left_boundary_entered"))


	# Initialize the top_scores array with 0s if it's empty
	if top_scores.is_empty():
		for i in range(10):
			top_scores.append(0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DisplayInstructions()
	
	# print(get_viewport_rect().size)
	elapsed_time += delta
	
	timeLabel.text = "Time: " + str(int(elapsed_time))
	if player.energy > 100:
		player.energy = 100
		player_energy = player.energy
	
	
	if ammo > ammoLabel.capacity:
		ammo = ammoLabel.capacity
	if ammo < 0:
		ammo = 0
	
	if player.energy <= 0 and not game_ended:
		game_ended = true
		await get_tree().create_timer(0.1).timeout
		_game_end()
	
	if start_run:
		if player.has_unlimited_ammo and player.holdWeapon:
			shoot_timer += delta
			if shoot_timer >= 0.05:
				player.shoot()
				shoot_timer = 0.0  # Res
			ammo = capacity
		# Increment the accumulated score based on the player's velocity
		accumulated_score += max(5, player.energy) * delta

		# Update the integer score variable when the accumulated score exceeds 1
		if accumulated_score >= 10.0:
			score += int(accumulated_score/10)
			if player.energy > 95:
				score += int(accumulated_score/10)
				scoreLabel.modulate = Color(1, 0, 0) # Red color
			elif player.energy > 75:
				score += int(accumulated_score/10)
				scoreLabel.modulate = Color(1, 0.5, 0)  # Orange color
			else:
				scoreLabel.modulate = Color(1, 1, 1)  # White color
			accumulated_score -= int(accumulated_score)
		scoreLabel.text = "Score: " + str(int(score))
		

	
	_tick_game(delta)
	
	

func _tick_game(_delta: float) -> void:
	updateGameState()
	
	handle_input()
	
	energyBar.energy = player.energy
	player_energy = player.energy
	ammoLabel.ammo = player.ammo
	ammoLabel.capacity = player.capacity
	
	player.ammo = ammo
	player.capacity = capacity
	
	apply_energy()
	
	
func handle_input():
	if Input.is_action_just_pressed("pause"):
		game_instruction_Display.visible = false
		if !get_tree().paused:
			
			_game_pause()
			if start_run:
				start_run = false
			else:
				start_run = true
		else:
			_on_resume_game()
	if start_run:
		if Input.is_action_just_pressed("Jump") and player.is_on_floor():
			player.velocity.y = Jump_velocity - player.energy * 2
		if Input.is_action_just_pressed("Jump") and player.is_on_floor() and player.can_slide:
			player.velocity.y = Jump_velocity - player.energy * 2
			player.can_slide = false
			
		
		if player.running or player.jump:
			var direction := Input.get_axis("left", "right")
			if direction == -1:
				player.velocity.x = direction * 1.5 *(Speed +player.energy)
			elif direction ==1:
				player.velocity.x = direction * (Speed + player.energy)
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, (Speed + player.energy))
		
		if player.holdWeapon and Input.is_action_just_pressed("ui_up"):
			player.shotGun.rotation_degrees = -90
			
			player.gunDirection = "up"
		if player.holdWeapon and Input.is_action_just_pressed("ui_right"):
			player.shotGun.rotation_degrees = 0
		
			player.gunDirection = "straight"
		
		if player.holdWeapon and player.gunDirection == "straight" and Input.is_action_just_pressed("ui_right") and player.has_ammo:
			player.shoot()
			if !player.has_unlimited_ammo:
				ammo -= 1
		if player.holdWeapon and player.gunDirection == "up" and Input.is_action_just_pressed("ui_up") and player.has_ammo:
			player.shoot()
			if !player.has_unlimited_ammo:
				ammo -= 1
		
		
		# Handle shield toggle input
		if Input.is_action_just_pressed("shield") and player.has_shield:
			# print("input detected for shield toggle")
			player.toggle_shield()
		
		if Input.is_action_just_pressed("slide") and player.is_on_floor():
			player.can_slide = true
		if Input.is_action_just_pressed("slide") and !player.is_on_floor():
			player.velocity.y = Jump_velocity * -1.5
		if Input.is_action_just_released("slide")  and player.is_on_floor():
			player.can_slide = false
		

	player.move_and_slide()

func _on_player_collided(energy_loss):
	if not player.is_invincible:
		player.decrement_energy(energy_loss)
		player.energy -= energy_loss
		player_energy = player.energy
		energyBar.energy = player.energy  # Update energy bar with player's energy
		camera.trigger_shake(1)

func _on_weapon_collided() :
	pass

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
	print("Game Over!")
	update_scoreboard(score)
	save_scores()  # Save the top scores when the game ends
	if game_instruction_Display.visible == true:
		game_instruction_Display.visible = false
	display_scoreboard()

	get_tree().paused = true
	
	game_over.global_position.x = 0
	game_over.global_position.y = 0
	
	game_over.scale = Vector2(0.5,0.5)
	
	game_over.visible = true

func _game_pause():
	print("Game paused!")
	get_tree().paused = true
	$PauseMusic.play()
	print("Game tree:", get_tree())
	game_paused.global_position.x = 0
	game_paused.global_position.y = 0
	game_paused.visible = true
	game_paused.scale = Vector2(0.5,0.5)
	
func _on_resume_game():
	print("Resume game signal received")
	print("Game tree before checking:", get_tree())
	print("Is node in tree?", is_inside_tree())  # Check if the node is part of the tree
	
	$PauseMusic.stop()
	if get_tree():
		get_tree().paused = false  # Resume the game
		game_paused.visible = false  # Hide the pause menu
		start_run = true
	else:
		print("Error: SceneTree is null, cannot resume game")
func _on_restart_game():
	print("Restarting game...")

	game_ended = false
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
		apply_knockback_to_player(body)
		$WallCollision.play()
		start_screen_shake()

func apply_knockback_to_player(player_body):
	var knockback_distance = 20  # Adjust as needed
	var target_position = player_body.position.x + knockback_distance
	
	# Use a tween to smoothly move the player
	var tween = get_tree().create_tween()
	tween.tween_property(player_body, "position:x", target_position, 0.2)  # 0.2 seconds duration


func start_screen_shake():
	# Reference to the camera (assumes a child camera node named "Camera2D")
	var camera = $Camera2D
	if camera:
		# Perform a screen shake using a tween
		var tween = get_tree().create_tween()
		for i in range(5):  # Number of shake cycles
			var offset = Vector2(randi() % 10 - 5, randi() % 10 - 5)  # Random offset within (-5, 5)
			tween.tween_property(camera, "offset", offset, 0.05)  # Small shake duration
		tween.tween_property(camera, "offset", Vector2.ZERO, 0.1)  # Reset to original position

# Update the scoreboard with the player's score
func update_scoreboard(player_score: int) -> void:
	top_scores.append(player_score)
	top_scores.sort()
	top_scores.reverse()
	if top_scores.size() > 10:
		top_scores.resize(10)

	# Display the scoreboard
func display_scoreboard() -> void:
	var scoreboard_text = "[center][b]Top 10 Scores:[/b]\n"
	for i in range(top_scores.size()):
		scoreboard_text += str(i + 1) + ".  " + str(top_scores[i]) + "\n"
	scoreboard_text += "[/center]"
	game_over.get_node("Control/ScoreLabel").bbcode_text = scoreboard_text
	game_over.visible = true


# Save the top 10 scores to a file
func save_scores():
	var file = FileAccess.open("user://top_scores.save", FileAccess.WRITE)
	if file:
		for score in top_scores:
			file.store_line(str(score))
		file.close()

# Load the top 10 scores from a file
func load_scores():
	var file = FileAccess.open("user://top_scores.save", FileAccess.READ)
	if file:
		top_scores.clear()
		while not file.eof_reached():
			var score = file.get_line().to_int()
			top_scores.append(score)
		file.close()
		top_scores.sort()
		top_scores.reverse()
		if top_scores.size() > 10:
			top_scores.resize(10)
			
			
func DisplayInstructions():
	
	game_instruction_Display.scale = Vector2(0.2, 0.2)
	game_instruction_Display.global_position.x = 250
	game_instruction_Display.global_position.y = 50
	await get_tree().create_timer(20).timeout
	game_instruction_Display.visible = false
