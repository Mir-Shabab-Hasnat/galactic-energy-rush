extends Area2D
var speed = 400
var direction = Vector2.ZERO 
func _process(delta: float) -> void:
	position += direction * speed * delta
	






func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
