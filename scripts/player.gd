extends CharacterBody2D

var can_move = false
var idle = false
var running = false
var jump = false

@onready var animated_player = $AnimatedSprite2D



func _ready():
	print(get_viewport_rect().size.x / 2)
	print(get_viewport_rect().size.y / 2)

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
