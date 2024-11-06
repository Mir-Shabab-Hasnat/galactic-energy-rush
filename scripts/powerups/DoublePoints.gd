# DoublePoints.gd
extends "res://scripts/powerups/power_up_effect.gd"

@onready var animated_sprite = $Sprite2D

func apply_effect(player):
    player.double_points = true

func remove_effect(player):
    player.double_points = false