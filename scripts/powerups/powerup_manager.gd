extends Node

# Preload the powerup scene
var PowerUpScene = preload("res://scenes/powerup.tscn")

@export var spawn_interval: float = 2
@export var energy_pickup_spawn_interval: float = 1.5  # More frequent spawn interval for ENERGY_PICKUP


# Preload the effect scenes
var InvincibilityEffectScript = preload("res://scripts/powerups/Invincibility.gd")
var ShieldEffectScript = preload("res://scripts/powerups/Shield.gd")
var EnergyPickupEffectScript = preload("res://scripts/powerups/EnergyPickup.gd")

# Define the PowerUpType enum
enum PowerUpType { INVINCIBILITY, SHIELD, ENERGY_PICKUP }

var start_spawn = false
var timer = 0.0
var energy_pickup_timer = 0.0

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

		if energy_pickup_timer >= energy_pickup_spawn_interval:
			spawn_energy_pickup()
			energy_pickup_timer = 0.0


func spawn_powerup() -> void:
	var power_up_type = randi() % PowerUpType.size()-1  # Randomly select a powerup type
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
		
		match power_up_type:
			PowerUpType.INVINCIBILITY:
				print("Invincibility powerup created")
				powerup.power_up_type = PowerUpType.INVINCIBILITY
				powerup.effect_script = InvincibilityEffectScript
			PowerUpType.SHIELD:
				print("Shield powerup created")
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
