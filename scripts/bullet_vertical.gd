extends Area2D

@export var velocity: Vector2 = Vector2(200, 0) # Default velocity of the projectile, moving to the right
@export var energy_multiplier: float = 3.0  # Multiplier to affect energy consumption
@export var damage: int = 5  # Damage value when colliding with the player

@onready var animated_sprite = $AnimatedSprite2D  # Assuming the projectile has an animated sprite

var can_move = false
var energy = 0
var game_instance

signal player_collided(damage)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_instance = get_node("/root/Game")
	# Add projectile to group for easier identification
	add_to_group("enemyProjectile")
	add_to_group("enemyObstacle") # Used for shield collision detection

	# Connect collision signal to detect when projectile hits player
	connect("body_entered", Callable(self, "_on_body_entered"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_move_state()
	update_energy()

	
	position += velocity * delta
	#free off screen
	if self.global_position.x < 0 :
		print("spcae bullet freed")
		queue_free()



# Update energy based on game state
func update_energy() -> void:
	if game_instance:
		energy = game_instance.player_energy * energy_multiplier

# Update the movement state of the projectile
func update_move_state() -> void:
	if game_instance:
		can_move = game_instance.start_run

# Handle what happens when the projectile collides with another body
func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_collided", damage)  # Emit a signal indicating a collision with the player
		queue_free()  # Remove the projectile after it hits the player
	
# Allow setting a new velocity for the projectile
func set_velocity(new_velocity: Vector2) -> void:
	velocity = new_velocity
