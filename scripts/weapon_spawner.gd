extends Node

# List of weapon scenes to spawn
@export var weapon_scenes: Array[PackedScene] = []
@export var min_spawn_interval: float = 5.0 # Minimum interval between spawns
@export var max_spawn_interval: float = 10.0 # Maximum interval between spawns
@export var spawn_area: Rect2 = Rect2(Vector2(577, 230), Vector2(10, 10))
@export var start_delay: float = 20 # Delay in seconds before starting to spawn

var _elapsed_time: float = 0 # Tracks how long the game has been running

func _ready():
	randomize()
	# Wait for the delay before starting the spawner
	start_after_delay()

# Function to handle the initial delay before starting to spawn
func start_after_delay() -> void:
	await get_tree().create_timer(start_delay).timeout
	start_spawning()

func start_spawning() -> void:
	_schedule_next_spawn()

func _schedule_next_spawn() -> void:
	var interval = randf_range(min_spawn_interval, max_spawn_interval)
	await get_tree().create_timer(interval).timeout
	spawn_weapon()
	_schedule_next_spawn()

func spawn_weapon() -> void:
	if weapon_scenes.is_empty():
		return

	# Randomly pick a weapon to spawn
	var weapon_scene = weapon_scenes[randi() % weapon_scenes.size()]
	var weapon_instance = weapon_scene.instantiate()
	
	# Spawn the weapon at a random position within the spawn area
	var spawn_position = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	weapon_instance.position = spawn_position
	add_child(weapon_instance)

func _process(delta: float) -> void:
	_elapsed_time += delta

	# Adjust spawn parameters as time progresses
	adjust_spawn_rate()

func adjust_spawn_rate() -> void:
	# Example: Decrease the interval range over time
	min_spawn_interval = max(0.2, 1.0 - _elapsed_time / 120.0) # Slowly reduce to a min of 0.2
	max_spawn_interval = max(1.0, 3.0 - _elapsed_time / 120.0) # Slowly reduce to a min of 1.0
