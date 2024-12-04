extends Control

var ammo = 0;
var capacity = 50;

@onready var ammoLabel = $current

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ammoLabel.text = str(ammo) + "/" + str(capacity)
