extends CharacterBody2D

const TYPE = "player"

enum PowerUpType { SHIELD, INVINCIBILITY, ENERGY_PICKUP }

var can_move = false
var idle = false
var running = false
var jump = false
var gun_run = false
var gun_jump = false
var slide = false
var can_slide = false
var is_invincible: bool = false
var has_shield = false
var shield_active: bool = false
var has_unlimited_ammo: bool = false
var energy: int = 50
var holdWeapon = false
var ammo: int = 0
var capacity: int = 0

var has_ammo = false
var energy_decrement_accumulator: float = 0.0

@onready var animated_player = $AnimatedSprite2D
@onready var shotGun = $Shotgun 
@onready var shield = $Shield
@onready var animated_shield = $Shield/AnimatedShield
@onready var shield_collision_shape = $Shield/CollisionShape2D
@onready var normal_collision_shape = $NormalCollisionShape
@onready var slide_collision_shape = $SlideCollisionShape
@onready var invincibilityIcon = $InvincibilityIcon

@onready var shield_icon = null
var shield_icon_scene = preload("res://scenes/ShieldIcon.tscn")

@onready var shotgunMuzzle = shotGun.get_node("Muzzle")
@export var bullet_scene: PackedScene

var gunDirection = "straight"

func _ready():
	shield.add_to_group("shield")
	shield.connect("body_entered", Callable(self, "_on_shield_body_entered"))
	shield.connect("area_entered", Callable(self, "_on_shield_area_entered"))
	normal_collision_shape.disabled = false
	slide_collision_shape.disabled = true
	invincibilityIcon.visible = false
	invincibilityIcon.play("default")
	
	
func _physics_process(delta: float) -> void:
	
	if ammo > 0:
		has_ammo = true
	if ammo <= 0:
		has_ammo = false
	# Add gravity
	gunLogic()
	handleSlide()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Decrement energy when the shield is active
	if shield_active:
		energy_decrement_accumulator += 10 * delta
		if energy_decrement_accumulator >= 1.0:
			decrement_energy(int(energy_decrement_accumulator))
			energy_decrement_accumulator -= int(energy_decrement_accumulator)
	
	
	if can_move:
		
		if position.y < 250 and !holdWeapon and !has_ammo and !can_slide:
			jump = true
			gun_jump = false
			running = false
			idle = false
			gun_run = false
			slide = false
		elif position.y < 250 and holdWeapon and has_ammo and !can_slide:
			jump = true
			gun_jump = true
			running = false
			idle = false
			gun_run = false
			slide = false
		
		elif  can_slide:
			jump = false
			gun_jump = false
			running = false
			idle = false
			gun_run = false
			slide = true
			
		elif holdWeapon and has_ammo and !can_slide:
			jump = false
			gun_jump = false
			running = true
			idle = false
			gun_run = true
			slide = false
		else:
			running = true
			gun_jump = false
			idle = false
			jump = false
			gun_run = false
			slide = false
		
	else:
		idle = true
	
	if idle:
		animated_player.play("idle")
	
	if jump and !gun_jump:
		animated_player.play("jump")
	if jump and gun_jump:
		animated_player.play("gun_jump")
	
	if running and !gun_run:
		animated_player.play("run")
	if gun_run and running and has_ammo:
		animated_player.play("gun")
	if slide:
		animated_player.play("slide")

	if is_invincible:
		animated_player.modulate = Color(1, 1, 1, 0.4)
		invincibilityIcon.visible = true
	elif has_shield and shield.visible:
		animated_shield.play("default")
		pass
	else:
		shield.visible = false
		invincibilityIcon.visible = false
		animated_player.modulate = Color(1, 1, 1, 1)


func decrement_energy(amount: int):
	if not is_invincible:
		energy -= amount

func _on_shield_body_entered(body):
	if has_shield and shield_active and body.is_in_group("enemyObstacle"):
		# print("Shield collided with body enemyObstacle: ", body.name)
		body.queue_free()

func _on_shield_area_shape_entered(area_shape):
	if has_shield and shield_active and area_shape.is_in_group("enemyObstacle"):
		# print("Shield collided with area_shape enemyObstacle: ", area_shape.name)
		area_shape.queue_free()

func _on_shield_area_entered(area):
	if has_shield and shield_active and area.is_in_group("enemyObstacle"):
		# print("Shield collided with area enemyObstacle: ", area.name)
		area.queue_free()
		
func gunLogic():
	if holdWeapon and has_ammo:
		shotGun.visible = true
		shotGun.play("default")
		if slide:
			shotGun.position.x = 17
			shotGun.position.y = -23
		else:
			shotGun.position.x = 18.5
			shotGun.position.y = -33.5
	else:
		shotGun.visible = false
		

func handleSlide():
	if slide:
		normal_collision_shape.disabled = true
		slide_collision_shape.disabled = false
		
	else :
		normal_collision_shape.disabled = false
		slide_collision_shape.disabled = true
		
	
	
func shoot():
	if bullet_scene and shotgunMuzzle:
		
		var bullet_instance = bullet_scene.instantiate()
		
		bullet_instance.global_position = shotgunMuzzle.global_position
		var direction = Vector2.RIGHT.rotated(shotgunMuzzle.global_rotation)
		bullet_instance.rotation = shotGun.global_rotation
		bullet_instance.direction = direction.normalized()  # Set bullet's direction
		get_parent().add_child(bullet_instance)
		$BulletSound.play()
		
		
		

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
		else:
			shield_active = true
			shield.visible = true
			
			check_and_free_existing_bodies()

func apply_shield():
	has_shield = true
	if not shield_icon:
		shield_icon = shield_icon_scene.instantiate()
		get_tree().root.add_child(shield_icon)
		shield_icon.scale = Vector2(0.5, 0.5)  # Scale the icon down
		shield_icon.position = Vector2(15, 40)  # Position the icon in the top-left corner
