# invincibility_effect.gd
extends "res://scripts/powerups/power_up_effect.gd"

func apply_effect(player):
    player.is_invincible = true

func remove_effect(player):
    player.is_invincible = false
