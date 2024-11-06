extends RigidBody2D

var energy = 0
var speed: float = 125
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	
	connect("body_entered", Callable(self, "_on_body_entered"))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport_rect = get_viewport().get_visible_rect()
	if global_position.x < viewport_rect.position.x:
		print("metal free at ", position.x)
		queue_free()
	pass


func _physics_process(delta: float) -> void:
# Apply a force to the right (increase x component to increase speed)
	position.x -= 125 * delta  # Move the body right at 100 pixels per second
