extends Node
@export var MetalBlock_scene = preload("res://scenes/MetalBlock.tscn")
@export var evil_eye_scene = preload("res://scenes/evil_eye.tscn")
@export var spawn_interval: float = 2.0

var start_spawn = false

var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_spawn:
		timer += delta
		if timer >= spawn_interval:
			
			spawn()
			spawnBox()
			timer = 0.0

func spawn() -> void:
	var evil_eye = evil_eye_scene.instantiate()
	add_child(evil_eye)
	evil_eye.can_move = true
	evil_eye.global_position.x = 630
	evil_eye.global_position.y = 200
	evil_eye.scale = Vector2(0.4, 0.4)
	
	
func spawnBox() -> void:
	
	var MetalBox= MetalBlock_scene.instantiate()
	add_child(MetalBox)
	
	
	MetalBox.global_position.x = 300
	MetalBox.global_position.y = 230
	
	print(MetalBox.global_position.x, " ",MetalBox.global_position.y)
