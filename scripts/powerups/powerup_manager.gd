extends Node

var PowerUpScene = preload("res://scenes/powerup.tscn")

@export var spawn_interval: float = 3.5
@export var energy_pickup_spawn_interval: float = 0.75  # More frequent spawn interval for ENERGY_PICKUP

@export var spawn_interval_variation: float = 0.5  # Maximum variation for powerup spawn interval
@export var energy_pickup_spawn_interval_variation: float = 0.5  # Maximum variation for energy pickup spawn interval

# Preload the effect scenes
var InvincibilityEffectScript = preload("res://scripts/powerups/Invincibility.gd")
var ShieldEffectScript = preload("res://scripts/powerups/Shield.gd")
var EnergyPickupEffectScript = preload("res://scripts/powerups/EnergyPickup.gd")

# Define the PowerUpType enum
enum PowerUpType { INVINCIBILITY, SHIELD, ENERGY_PICKUP }

var start_spawn = false
var timer = 0.0
var energy_pickup_timer = -1.0
var shield_spawn_time: float = 5.0  # Time in seconds after which the Shield powerup can start spawning


var game_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_instance = get_node("/root/Game")


func _process(delta: float) -> void:
	if start_spawn:
		timer += delta
		energy_pickup_timer += delta

		if timer >= spawn_interval:
			spawn_powerup()
			timer = 0.0
			# Add random variation to the next spawn interval
			spawn_interval += randf_range(-spawn_interval_variation, spawn_interval_variation)
			# Clamp the spawn interval to stay within reasonable bounds
			spawn_interval = clamp(spawn_interval, 2.0, 5.0)

		if energy_pickup_timer >= energy_pickup_spawn_interval:
			spawn_energy_pickup()
			energy_pickup_timer = 0.0
			# Add random variation to the next energy pickup spawn interval
			energy_pickup_spawn_interval += randf_range(-energy_pickup_spawn_interval_variation, energy_pickup_spawn_interval_variation)
			# Clamp the energy pickup spawn interval to stay within reasonable bounds
			energy_pickup_spawn_interval = clamp(energy_pickup_spawn_interval, 0.25, 1.5)


func spawn_powerup() -> void:
	var power_up_type = randi() % PowerUpType.size()  # Randomly select a powerup type

	if power_up_type == PowerUpType.ENERGY_PICKUP:
		# select a different powerup type
		if randi() % 2 == 0:
			power_up_type = PowerUpType.INVINCIBILITY
		else:
			power_up_type = PowerUpType.SHIELD
			
	# Ensure Shield powerup doesn't spawn before the specified time
	if power_up_type == PowerUpType.SHIELD and game_instance.elapsed_time < shield_spawn_time:
		# select a different powerup type
		power_up_type = PowerUpType.INVINCIBILITY

	var viewport_rect = get_viewport().get_visible_rect()
	var powerup = create_powerup(power_up_type)
	add_child(powerup)
	powerup.can_move = true
	powerup.global_position.x = viewport_rect.size.x + 20 # Spawn just off the right side
	powerup.global_position.y = 225
	powerup.game_instance = game_instance  # Pass the game reference to the powerup


func spawn_energy_pickup() -> void:
	var viewport_rect = get_viewport().get_visible_rect()
	var powerup = create_energy_pickup()
	add_child(powerup)
	powerup.can_move = true
	powerup.global_position.x = viewport_rect.size.x + 20 # Spawn just off the right side
	powerup.global_position.y = 225
	powerup.game_instance = game_instance  # Pass the game reference to the powerup


func create_powerup(power_up_type: int) -> Node:
	if PowerUpScene:
		var powerup = PowerUpScene.instantiate()
		print("Powerup type: ", power_up_type)
		match power_up_type:
			PowerUpType.INVINCIBILITY:
				# print("Invincibility powerup created")
				powerup.power_up_type = PowerUpType.INVINCIBILITY
				powerup.effect_script = InvincibilityEffectScript
			PowerUpType.SHIELD:
				# print("Shield powerup created")
				powerup.power_up_type = PowerUpType.SHIELD
				powerup.effect_script = ShieldEffectScript
		
		return powerup
	else:
		print("Error: PowerUpScene is not preloaded correctly")
		return null


func create_energy_pickup() -> Node:
	if PowerUpScene:
		var powerup = PowerUpScene.instantiate()
		powerup.power_up_type = PowerUpType.ENERGY_PICKUP
		powerup.effect_script = EnergyPickupEffectScript
		return powerup
	else:
		print("Error: PowerUpScene is not preloaded correctly")
		return null
