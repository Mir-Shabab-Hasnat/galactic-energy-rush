extends Control
# Declare the custom signal
signal restart_game
signal exit_game
signal resume_game

@onready var ResumeButton = $VBoxContainer/ResumeButton
# Called when the node enters the scene tree for the first time.
func _ready():
	pass





func _on_exit_button_pressed() -> void:
	print("exit button pressed")
	emit_signal("exit_game")
	


func _on_resume_button_pressed() -> void:
	print("Resume button pressed")
	emit_signal("resume_game")



func _on_restart_button_pressed() -> void:
	print("Restart button pressed")
	emit_signal("restart_game")
