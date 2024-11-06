# power_up.gd
extends Area2D

enum PowerUpType { INVINCIBILITY, DOUBLE_POINTS }

var power_up_type: PowerUpType 
var effect_script: GDScript
var can_move = false
var energy = 0

@export var speed: float = 200;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move:
		position.x -= (speed + energy) * delta

func _ready():
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player":
		apply_power_up(body)
		queue_free()


func apply_power_up(player):
	if effect_script:
		var effect_instance = effect_script.new()
		get_tree().root.add_child(effect_instance)
		effect_instance.start_effect(player)
		print("Powerup applied: ", power_up_type)
	else:
		print("Error: effect_script is not set")
