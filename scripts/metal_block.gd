extends RigidBody2D

var energy = 0
var speed: float = 125
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	linear_velocity = Vector2(-1000, 0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	# Apply a force to the right (increase x component to increase speed)
	pass
