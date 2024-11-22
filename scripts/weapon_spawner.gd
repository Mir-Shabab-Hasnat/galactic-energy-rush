extends Node

# List of weapon scenes to spawn
@export var weapon_scenes: Array[PackedScene] = []
@export var min_spawn_interval: float = 2 # Initial minimum interval between spawns
@export var max_spawn_interval: float = 3.0 # Initial maximum interval between spawns
@export var spawn_area: Rect2 = Rect2(Vector2(577, 230), Vector2(10, 10)) # Fixed spawn area
@export var start_delay: float = 2 # Delay in seconds before starting to spawn

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
	# Add randomness to spawn intervals
	var interval = randf_range(min_spawn_interval, max_spawn_interval) + randf() * 2.0
	await get_tree().create_timer(interval).timeout
	spawn_weapon()
	_schedule_next_spawn()

func spawn_weapon() -> void:
	if weapon_scenes.is_empty():
		return

	# Randomly pick a weapon to spawn
	var weapon_scene = weapon_scenes[randi() % weapon_scenes.size()]
	var weapon_instance = weapon_scene.instantiate()
	
	# Spawn the weapon at a random position within the fixed spawn area
	var spawn_position = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	weapon_instance.position = spawn_position
	add_child(weapon_instance)

func _process(delta: float) -> void:
	_elapsed_time += delta

	# Adjust spawn intervals as time progresses
	adjust_spawn_rate()

func adjust_spawn_rate() -> void:
	# Decrease the interval range over 5 minutes (300 seconds)
	var time_factor = _elapsed_time / 300.0
	min_spawn_interval = lerp(min_spawn_interval, 2.0, clamp(time_factor, 0, 1)) # Min interval reduces from 8s to 2s
	max_spawn_interval = lerp(max_spawn_interval, 5.0, clamp(time_factor, 0, 1)) # Max interval reduces from 15s to 5s
