extends CharacterBody2D

const TYPE = "player"

enum PowerUpType { SHIELD, INVINCIBILITY, ENERGY_PICKUP }

var can_move = false
var idle = false
var running = false
var jump = false
var is_invincible: bool = false
var has_shield = false
var shield_active: bool = false
var energy: int = 50
var holdWeapon = false
var ammo: int = 0

var has_ammo = false
var energy_decrement_accumulator: float = 0.0

@onready var animated_player = $AnimatedSprite2D
@onready var shotGun = $Shotgun 
@onready var shield = $Shield
@onready var animated_shield = $Shield/AnimatedShield
@onready var shield_collision_shape = $Shield/CollisionShape2D
@onready var shield_debug_sprite = $Shield/DebugSprite  # Temporary debug sprite

@onready var shotgunMuzzle = shotGun.get_node("Muzzle")
@export var bullet_scene: PackedScene

var gunDirection = "straight"

func _ready():
	shield.add_to_group("shield")
	shield.connect("body_entered", Callable(self, "_on_shield_body_entered"))
	shield.connect("area_entered", Callable(self, "_on_shield_area_entered"))
	
	
func _physics_process(delta: float) -> void:
	
	if ammo > 0:
		has_ammo = true
	if ammo <= 0:
		has_ammo = false
	# Add gravity
	gunLogic()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Decrement energy when the shield is active
	if shield_active:
		energy_decrement_accumulator += 10 * delta
		if energy_decrement_accumulator >= 1.0:
			decrement_energy(int(energy_decrement_accumulator))
			energy_decrement_accumulator -= int(energy_decrement_accumulator)
	
	
	if can_move:
		if position.y < 250:
			jump = true
			running = false
			idle = false
		else:
			running = true
			idle = false
			jump = false
		
	else:
		idle = true
	
	if idle:
		animated_player.play("idle")
	
	if jump:
		animated_player.play("jump")
	
	if running:
		animated_player.play("run")

	if is_invincible:
		animated_player.modulate = Color(1, 1, 1, 0.4)
	elif has_shield and shield.visible:
		shield.visible = true
		animated_shield.play("default")
		pass
	else:
		shield.visible = false
		animated_player.modulate = Color(1, 1, 1, 1)


func decrement_energy(amount: int):
	if not is_invincible:
		energy -= amount

func _on_shield_body_entered(body):
	if has_shield and shield_active and body.is_in_group("enemyObstacle"):
		# print("Shield collided with enemyObstacle: ", body.name)
		# Push the enemy away or vaporize it
		body.queue_free()


func _on_shield_area_entered(area):
	if has_shield and shield_active and area.is_in_group("enemyObstacle"):
		# print("Shield collided with enemyObstacle: ", area.name)
		# Push the enemy away or vaporize it
		area.queue_free()
		
func gunLogic():
	if holdWeapon:
		shotGun.visible = true
		shotGun.play("default")
	else:
		shotGun.visible = false
		
func shoot():
	if bullet_scene and shotgunMuzzle:
		
		var bullet_instance = bullet_scene.instantiate()
		
		bullet_instance.global_position = shotgunMuzzle.global_position
		var direction = Vector2.RIGHT.rotated(shotgunMuzzle.global_rotation)
		bullet_instance.rotation = shotGun.global_rotation
		bullet_instance.direction = direction.normalized()  # Set bullet's direction
		get_parent().add_child(bullet_instance)
		
		

func check_and_free_existing_bodies():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = shield_collision_shape.shape.get_rid()
	query.transform = shield_collision_shape.global_transform
	query.margin = 0.1
	var result = space_state.intersect_shape(query, 32)  # Corrected call
	for item in result:
		var body = item.collider
		if body and body.is_in_group("enemyObstacle"):
			body.queue_free()

func toggle_shield():
	if has_shield:
		if shield_active:
			shield_active = false
			shield.visible = false
			shield_debug_sprite.visible = false
			
			shield_debug_sprite.stop()
		else:
			shield_active = true
			shield.visible = true
			shield_debug_sprite.visible = true
			shield_debug_sprite.play()
			check_and_free_existing_bodies()
