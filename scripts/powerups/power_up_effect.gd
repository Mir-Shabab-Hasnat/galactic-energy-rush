# power_up_effect.gd
extends Node

@export var duration: float = 5.0

func apply_effect(player):
    # To be overridden by subclasses
    pass

func remove_effect(player):
    # To be overridden by subclasses
    pass

func start_effect(player):
    apply_effect(player)
    await get_tree().create_timer(duration).timeout
    remove_effect(player)
    queue_free()