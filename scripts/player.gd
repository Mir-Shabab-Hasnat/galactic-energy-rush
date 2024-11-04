extends CharacterBody2D

var can_move = false
var idle = false
var running = false
var jump = false

@onready var animated_player = $AnimatedSprite2D

func _ready():
	pass

func _physics_process(delta: float) -> void:
	# Add gravity
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if can_move:
		if position.y < 290:
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
