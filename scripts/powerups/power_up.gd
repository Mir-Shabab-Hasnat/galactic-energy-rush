# power_up.gd
extends Area2D

enum PowerUpType { INVINCIBILITY, DOUBLE_POINTS }

var power_up_type: PowerUpType 
var effect_script: GDScript

func _ready():
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player":
		apply_power_up(body)
		queue_free()


func apply_power_up(player):
	if effect_script:
		var effect_instance = effect_script.new()
		effect_instance.start_effect(player)
		get_tree().root.add_child(effect_instance)
		print("Powerup applied: ", power_up_type)
	else:
		print("Error: effect_script is not set")
