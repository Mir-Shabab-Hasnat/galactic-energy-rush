# DoublePoints.gd
extends "res://scripts/powerups/power_up_effect.gd"

func apply_effect(player):
    player.double_points = true

func remove_effect(player):
    player.double_points = false