extends Node

@export var duration: float = 5.0
var timer: Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = duration
	timer.connect("timeout", Callable(self, "_on_timeout"))
	add_child(timer)

func apply_effect(_player):
	# To be overridden by subclasses
	pass

func remove_effect(_player):
	# To be overridden by subclasses
	pass

func start_effect(player):
	apply_effect(player)
	timer.start()

func refresh_duration():
	timer.start()

func _on_timeout():
	remove_effect(get_parent())
	queue_free()
