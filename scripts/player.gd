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
@onready var shield = $Shield
@onready var shield_collision_shape = $Shield/CollisionShape2D
@onready var shield_debug_sprite = $Shield/DebugSprite  # Temporary debug sprite

func _ready():
	shield.add_to_group("shield")
	shield.connect("body_entered", Callable(self, "_on_shield_body_entered"))
	shield.connect("area_entered", Callable(self, "_on_shield_area_entered"))
	
	
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
	elif has_shield:
		shield.visible = true
		animated_player.modulate = Color(0, 0, 1, 1) # Blue color for shield
	else:
		shield.visible = false
		animated_player.modulate = Color(1, 1, 1, 1)


func decrement_energy(amount: int):
	if not is_invincible:
		energy -= amount

func _on_shield_body_entered(body):
	if has_shield and body.is_in_group("enemyObstacle"):
		# print("Shield collided with enemyObstacle: ", body.name)
		# Push the enemy away or vaporize it
		body.queue_free()


func _on_shield_area_entered(area):
	if has_shield and area.is_in_group("enemyObstacle"):
		# print("Shield collided with enemyObstacle: ", area.name)
		# Push the enemy away or vaporize it
		area.queue_free()
