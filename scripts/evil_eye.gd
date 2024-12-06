extends Area2D

var can_move = false
var energy = 0
@onready var animated_sprite = $AnimatedSprite2D

@export var speed: float = 200;

var game_instance 
signal player_collided(damage)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("idle")
	add_to_group("enemyObstacle") # Used for shield collision detection
	game_instance = get_node("/root/Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport_rect = get_viewport().get_visible_rect()
	update_move_state()
	update_energy()
	if can_move:
		position.x -= (speed + (energy*2)) * delta
		
	if global_position.x < viewport_rect.position.x:
		# print("eye free at ", position.x)
		queue_free()
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Evil Eye collided with player")
		emit_signal("player_collided", 5)  # Example damage value
		queue_free()
		


func update_energy() -> void:
	energy = game_instance.player_energy * 3

func update_move_state() -> void:
	can_move = game_instance.start_run


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		print("enemy shot")
		$AnimatedSprite2D.play("death")
		$DeathSound.play()
		
		await game_instance.get_tree().create_timer(0.25).timeout
		queue_free()	
