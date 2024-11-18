extends Control
# Declare the custom signal
signal restart_game
signal exit_game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure the RestartButton is connected
	pass

# Function called when the RestartButton is pressed
func _on_restart_button_pressed() -> void:
	print("Restart button pressed")
	# Reload the game scene
	emit_signal("restart_game")


func _on_exit_button_pressed() -> void:
	print("exit button pressed")
	emit_signal("exit_game")
	
	
