# UnlimitedAmmo.gd
extends "res://scripts/powerups/power_up_effect.gd"


# @onready var animated_sprite = $Sprite2D

func apply_effect(player):
	player.ammo = 15
	player.has_unlimited_ammo = true

func remove_effect(player):
	player.has_unlimited_ammo = false
