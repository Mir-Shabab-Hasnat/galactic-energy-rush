extends Node
@export var MetalBlock_scene = preload("res://scenes/MetalBlock.tscn")
@export var evil_eye_scene = preload("res://scenes/evil_eye.tscn")
@export var floatingPlatform_scene = preload("res://scenes/floating_platform.tscn")
@export var spawn_interval: float = randf_range(1.5,3.5)

@onready var game_instance = get_node("/root/Game")

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
			#spawnFloatingplatform()
			timer = 0.0

func spawn() -> void:
	var evil_eye = evil_eye_scene.instantiate()
	
	add_child(evil_eye)
	evil_eye.connect("player_collided", Callable(game_instance, "_on_player_collided"))
	evil_eye.can_move = true
	evil_eye.global_position.x = 630
	evil_eye.global_position.y = 200
	evil_eye.scale = Vector2(0.4, 0.4)
	
	
	
	
func spawnBox() -> void:
	
	var MetalBox= MetalBlock_scene.instantiate()
	add_child(MetalBox)
	var height = randf_range(0.5,1.5)
	
	MetalBox.scale = Vector2(0.5, height)
	MetalBox.global_position.x = 640
	MetalBox.global_position.y = 220
	
	# print(MetalBox.global_position.x, " ",MetalBox.global_position.y)

func spawnFloatingplatform() -> void:
	
	var flPlatform = floatingPlatform_scene.instantiate()
	add_child(flPlatform)
	var height = randf_range(150,200)
	
	
	flPlatform.global_position.x = 500
	flPlatform.global_position.y = height
	
	# print(flPlatform.global_position.x, " ",flPlatform.global_position.y)
