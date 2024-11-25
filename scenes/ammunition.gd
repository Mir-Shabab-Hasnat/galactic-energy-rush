extends Control

var ammo = 0;
var game_instance

@onready var ammoLabel = $current

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_instance = get_node("/root/Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_ammo()
	ammoLabel.text = str(ammo)

func update_ammo() -> void:
	ammo = game_instance.ammo
