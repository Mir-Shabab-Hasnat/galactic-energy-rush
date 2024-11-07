# power_up.gd
extends Area2D

enum PowerUpType { INVINCIBILITY, DOUBLE_POINTS, ENERGY_PICKUP }

var power_up_type: PowerUpType 
var effect_script: GDScript
var can_move = false
var energy = 0
var game

@export var speed: float = 200;
@onready var sprite = $powerupSprite  # Reference to the Sprite2D node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move:
		position.x -= (speed + energy) * delta

	# Check if the powerup is off-screen
	var viewport_rect = get_viewport().get_visible_rect()
	if position.x < viewport_rect.position.x:
		queue_free()

func _ready():
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	set_powerup_color()

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player":
		apply_power_up(body)
		queue_free()


func apply_power_up(player):
	if power_up_type == PowerUpType.ENERGY_PICKUP:
		if game:
			if game.energy <= 100:
				game.energy += 10  # Increment the energy value in the game node
			print("Applied Energy increased by 10. Current energy: ", game.appliedEnergy)
			print("Energy increased by 10. Current energy: ", game.energy)
		else:
			print("Error: game reference is not set")
	else:
		if effect_script:
			var effect_instance = effect_script.new()
			get_tree().root.add_child(effect_instance)
			effect_instance.start_effect(player)
			print("Powerup applied: ", power_up_type)
		else:
			print("Error: effect_script is not set")


func set_powerup_color():
	match power_up_type:
		PowerUpType.INVINCIBILITY:
			sprite.modulate = Color(1, 1, 1, 0.4)  # White color for invincibility
		PowerUpType.DOUBLE_POINTS:
			sprite.modulate = Color(0, 1, 0)  # Green color for double points
		PowerUpType.ENERGY_PICKUP:
			sprite.modulate = Color(0, 0, 1)  # Blue color for energy pickup
