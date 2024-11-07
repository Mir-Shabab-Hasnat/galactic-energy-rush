extends Area2D

var can_move = false
var energy = 0
@onready var animated_sprite = $AnimatedSprite2D

@export var speed: float = 200;

var game_instance 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_instance = get_node("/root/Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	update_energy()
	if can_move:
		animated_sprite.play("idle")
		position.x -= (speed + energy) * delta

func update_energy() -> void:
	
	energy = game_instance.energy * 3
