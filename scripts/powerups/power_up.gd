# power_up.gd
extends Area2D

enum PowerUpType { INVINCIBILITY, SHIELD, ENERGY_PICKUP }

var power_up_type: PowerUpType 
var effect_script: GDScript
var can_move = false
var energy = 0
var game_instance

@export var speed: float = 125.0;
@onready var sprite = $powerupSprite  # Reference to the Sprite2D node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_move_state()
	update_energy()
	if can_move:
		position.x -= (speed + energy) * delta

	# Check if the powerup is off-screen
	var viewport_rect = get_viewport().get_visible_rect()
	if position.x < viewport_rect.position.x:
		queue_free()

func update_move_state() -> void:
	can_move = game_instance.start_run

func _ready():
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	set_powerup_color()

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player":
		apply_power_up(body)
		queue_free()


func update_energy() -> void:
	energy = game_instance.player_energy * 3

func apply_power_up(player):
	if power_up_type == PowerUpType.ENERGY_PICKUP: 
		if player:
			if player.energy <= 100:
				player.energy += 3  # Increment the energy value in the game node
		else:
			print("Error: player reference is not set")
	else:
		if effect_script:
			var effect_group_name = "effect_" + str(power_up_type)
			var existing_effect = player.get_node_or_null(effect_group_name)
			# print("if existing_effect: ", existing_effect)
			if existing_effect:
				existing_effect.refresh_duration()
			else:
				var effect_instance = effect_script.new()
				player.add_child(effect_instance)
				effect_instance.name = effect_group_name
				effect_instance.start_effect(player)
		else:
			print("Error: effect_script is not set")


func set_powerup_color():
	match power_up_type:
		PowerUpType.INVINCIBILITY:
			sprite.modulate = Color(1, 1, 1, 0.4)  # White color for invincibility
		PowerUpType.SHIELD:
			sprite.modulate = Color(0, 1, 0)  # Green color for shield
		PowerUpType.ENERGY_PICKUP:
			sprite.modulate = Color(0, 0, 1)  # Blue color for energy pickup
