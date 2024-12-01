extends RigidBody2D

var energy = 0
var speed: float = 125
var game_instance 
var can_move
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	add_to_group("enemyObstacle") # Used for shield collision detection
	gravity_scale = 0
	game_instance = get_node("/root/Game")
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_move_state()
	update_energy()
	var viewport_rect = get_viewport().get_visible_rect()
	
	# Apply a force to the right (increase x component to increase speed)
	if can_move:
		position.x -= (speed + energy) * delta  # Move the body right at 100 pixels per second
	
	if global_position.x < viewport_rect.position.x:
		# print("metal free at ", position.x)
		queue_free()
	pass


func _physics_process(_delta: float) -> void:
	pass

func update_energy() -> void:
	energy = game_instance.player_energy * 3
	
func update_move_state() -> void:
	can_move = game_instance.start_run
