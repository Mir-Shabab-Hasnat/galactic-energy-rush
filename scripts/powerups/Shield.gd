# Shield.gd
extends "res://scripts/powerups/power_up_effect.gd"

func apply_effect(player):
	# Allow the player to toggle the shield on and off
	player.has_shield = true
	# Show the Shield Icon
	player.apply_shield()

func remove_effect(player):
	# Shield is never removed
	pass
