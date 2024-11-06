extends Node

# Preload the powerup scene
var PowerUpScene = preload("res://scenes/powerup.tscn")

# Preload the effect scenes
var InvincibilityEffectScene = preload("res://scripts/powerups/Invincibility.gd")
var DoublePointsEffectScene = preload("res://scripts/powerups/DoublePoints.gd")

# Define the PowerUpType enum
enum PowerUpType { INVINCIBILITY, DOUBLE_POINTS }

func create_powerup(power_up_type: int, position: Vector2) -> Node:
	if PowerUpScene:
		var powerup = PowerUpScene.instantiate()
		powerup.position = position
		
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
