extends Area2D
var energy = 0
@export var speed: float = 200;
var game_instance 
var can_move = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_instance = get_node("/root/Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport_rect = get_viewport().get_visible_rect()
	update_move_state()
	update_energy()
	if can_move:
		
		position.x -= (speed + energy) * delta
		
	if global_position.x < viewport_rect.position.x:
		# print("eye free at ", position.x)
		queue_free()
		

		
func update_energy() -> void:
	energy = game_instance.player_energy * 3

func update_move_state() -> void:
	can_move = game_instance.start_run		


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# print("Evil Eye collided with player")
		body.holdWeapon = true
		game_instance.ammo += 15
		game_instance.capacity += 2
		queue_free()
