# power_up.gd
extends Area2D

enum PowerUpType { INVINCIBILITY, DOUBLE_POINTS }

@export var power_up_type: PowerUpType
@export var effect_scene: PackedScene

func _on_body_entered(body):
    if body.is_in_group("Player"):
        apply_power_up(body)
        queue_free()

func apply_power_up(player):
    var effect_instance = effect_scene.instance()
    player.add_child(effect_instance)
    effect_instance.start_effect(player)