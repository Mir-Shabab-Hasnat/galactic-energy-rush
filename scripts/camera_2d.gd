extends Camera2D

var shake_intensity = 0.0  # How strong the shake is
var shake_decay = 1.5    # How fast the shake fades out

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_intensity > 0:
		# Apply random shake offset
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		shake_intensity -= shake_decay * delta  # Reduce shake over time
		if shake_intensity < 0:
			shake_intensity = 0  # Stop shaking

func trigger_shake(intensity: float):
	shake_intensity = intensity
