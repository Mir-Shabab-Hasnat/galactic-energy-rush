extends Node2D

var scroll_speed: float = 100.0
@onready var background1 = $Background1  # Ensure these are the correct names of your sprite nodes
@onready var background2 = $Background2  # Ensure these are the correct names of your sprite nodes


func _process(delta: float) -> void:
	# Move the backgrounds
	background1.position.x -= scroll_speed * delta
	background2.position.x -= scroll_speed * delta
	
	# Check if background1 has gone off-screen
	if background1.position.x < -background1.texture.get_size().x:
		background1.position.x = background2.position.x + background2.texture.get_size().x

	# Check if background2 has gone off-screen
	if background2.position.x < -background2.texture.get_size().x:
		background2.position.x = background1.position.x + background1.texture.get_size().x
	 
