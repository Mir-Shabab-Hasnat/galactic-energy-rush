# Shield.gd
extends "res://scripts/powerups/power_up_effect.gd"

# @onready var animated_sprite = $Sprite2D

func apply_effect(player):
	# print("Player has a shield")
	player.has_shield = true

func remove_effect(player):
	player.has_shield = false
