extends CanvasLayer

@onready var healthView = $TextureProgressBar
var health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthView.health = health
