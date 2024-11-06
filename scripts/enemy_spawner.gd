extends Node

@export var evil_eye_scene = preload("res://scenes/evil_eye.tscn")
@export var spawn_interval: float = 2.0

var start_spawn = true

var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer >= spawn_interval:
		spawn()
		timer = 0.0

func spawn() -> void:
	var evil_eye = evil_eye_scene.instantiate()
	add_child(evil_eye)
	evil_eye.can_move = true
	evil_eye.global_position.x = 630
	evil_eye.global_position.y = 200
	evil_eye.scale = Vector2(0.4, 0.4)
	print(evil_eye.position.x)
	print(evil_eye.position.y)
