extends Node

# Preload the powerup scene
var PowerUpScene = preload("res://scenes/powerup.tscn")

@export var spawn_interval: float = 10.0

# Preload the effect scenes
var InvincibilityEffectScene = preload("res://scripts/powerups/Invincibility.gd")
var DoublePointsEffectScene = preload("res://scripts/powerups/DoublePoints.gd")

# Define the PowerUpType enum
enum PowerUpType { INVINCIBILITY, DOUBLE_POINTS }

var start_spawn = false
var timer = 0.0


func _process(delta: float) -> void:
	if start_spawn:
		timer += delta
		if timer >= spawn_interval:
			spawn_powerup()
			timer = 0.0

func spawn_powerup() -> void:
	var power_up_type = randi() % PowerUpType.size()  # Randomly select a powerup type
	var viewport_rect = get_viewport().get_visible_rect()
	var powerup = create_powerup(power_up_type)
	add_child(powerup)
	powerup.can_move = true
	powerup.global_position.x = viewport_rect.size.x + 20 # Spawn just off the right side
	powerup.global_position.y = 225
	print("Powerup spawned: ", powerup.power_up_type)
	print("At x: ", powerup.global_position.x, " y: ", powerup.global_position.y)

func create_powerup(power_up_type: int) -> Node:
	if PowerUpScene:
		var powerup = PowerUpScene.instantiate()
		
		match power_up_type:
			PowerUpType.INVINCIBILITY:
				powerup.power_up_type = PowerUpType.INVINCIBILITY
				powerup.effect_script = InvincibilityEffectScene
			PowerUpType.DOUBLE_POINTS:
				powerup.power_up_type = PowerUpType.DOUBLE_POINTS
				powerup.effect_script = DoublePointsEffectScene
		
		return powerup
	else:
		print("Error: PowerUpScene is not preloaded correctly")
		return null
