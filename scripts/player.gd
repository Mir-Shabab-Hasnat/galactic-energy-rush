extends CharacterBody2D

const TYPE = "player"

var can_move = false
var idle = false
var running = false
var jump = false
var is_invincible: bool = false
var has_shield = false
var energy: int = 50

@onready var animated_player = $AnimatedSprite2D

func _ready():
	pass
	
	
	
func _physics_process(delta: float) -> void:
	# Add gravity
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if can_move:
		if position.y < 250:
			jump = true
			running = false
			idle = false
		else:
			running = true
			idle = false
			jump = false
		
	else:
		idle = true
	
	if idle:
		animated_player.play("idle")
	
	if jump:
		animated_player.play("jump")
	
	if running:
		animated_player.play("run")

	if is_invincible:
		animated_player.modulate = Color(1, 1, 1, 0.4)
	else:
		animated_player.modulate = Color(1, 1, 1, 1)
	
	
	if has_shield:
		animated_player.modulate = Color(0, 0, 1, 1) # Blue color for shield
	else:
		animated_player.modulate = Color(1, 1, 1, 1)


func decrement_energy(amount: int):
	if not is_invincible:
		energy -= amount