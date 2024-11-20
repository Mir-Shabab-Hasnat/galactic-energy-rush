# Shield.gd
extends "res://scripts/powerups/power_up_effect.gd"


@export var energy_decrement: int = 5  # Amount of energy to decrement each second

# var shield_active = false
# var shield_timer: Timer

# func _ready():
# 	shield_timer = Timer.new()
# 	shield_timer.wait_time = 1.0  # Decrement energy every second
# 	shield_timer.connect("timeout", Callable(self, "_on_shield_timer_timeout"))
# 	add_child(shield_timer)

func apply_effect(player):
	# Allow the player to toggle the shield on and off
	player.has_shield = true
	player.shield_active = false  # Ensure the shield is initially inactive
	player.shield.visible = false  # Ensure the shield is initially invisible

func remove_effect(player):
	# Shield is never removed?
	pass
	# player.has_shield = false
	# player.shield_active = false
	# shield_active = false
	# #shield_timer.stop()
	# player.shield.visible = false

# func toggle_shield(player):
# 	print("(shield) Toggling shield")
# 	if shield_active:
# 		print("Shield deactivated")
# 		shield_active = false
# 		player.shield_active = false
# 		shield_timer.stop()
# 		player.shield.visible = false
# 		player.animated_player.modulate = Color(1, 1, 1, 1)
# 	else:
# 		print("Shield activated")
# 		shield_active = true
# 		player.shield_active = true
# 		shield_timer.start()
# 		player.shield.visible = true
# 		player.animated_player.modulate = Color(0, 0, 1, 1)  # Blue color for shield

# func _on_shield_timer_timeout():
# 	if shield_active and get_parent().energy > 0:
# 		get_parent().decrement_energy(energy_decrement)
