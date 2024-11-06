# power_up_effect.gd
extends Node

@export var duration: float = 5.0

func apply_effect(_player):
	# To be overridden by subclasses
	pass

func remove_effect(_player):
	# To be overridden by subclasses
	pass

func start_effect(player):
	apply_effect(player)    
	if get_tree():
		await get_tree().create_timer(duration).timeout
	else:
		print("Error: Node is not added to the scene tree")
	remove_effect(player)
	queue_free()
