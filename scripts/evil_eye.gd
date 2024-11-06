extends Area2D

var can_move = false
var energy = 0
@onready var animated_sprite = $AnimatedSprite2D

@export var speed: float = 200;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Connect the collision detection signal
	connect("body_entered" ,Callable(self, "_on_body_entered"))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move:
		animated_sprite.play("idle")
		position.x -= (speed + energy) * delta

func _on_body_entered(body):
	if body.is_in_group("player"):  # Assuming obstacles are in an "obstacles" group
		print("Collision with obstacle detected!")
		queue_free()
		
