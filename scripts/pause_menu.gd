extends Control

# Declare custom signals
signal restart_game
signal exit_game
signal resume_game

# Get references to key UI elements
@onready var ResumeButton = $VBoxContainer/ResumeButton
@onready var RestartButton = $VBoxContainer/RestartButton
@onready var ExitButton = $VBoxContainer/ExitButton
@onready var ControlsButton = $VBoxContainer/controls
@onready var VolumeSlider = $VolumeSlider
@onready var ControlsPanel = $Controls
@onready var ControlsBackButton = $Controls/BackButton
@onready var ControlsLabel = $Controls/ControlsLabel
@onready var AudioBus = "Master"  # Audio bus for volume control

func _ready() -> void:
	# Connect button signals
	#ResumeButton.connect("pressed", Callable(self, "_on_resume_button_pressed"))
	#RestartButton.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	#ExitButton.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	#ControlsButton.connect("pressed", Callable(self, "_on_controls_button_pressed"))
	#ControlsBackButton.connect("pressed", Callable(self, "_on_back_button_pressed"))

	# Connect the volume slider's value_changed signal
	VolumeSlider.connect("value_changed", Callable(self, "_on_volume_slider_changed"))

	# Initialize the volume slider to reflect the current audio bus volume
	var current_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(AudioBus))
	VolumeSlider.value = db_to_linear(current_db)

	# Ensure the controls panel is hidden initially
	ControlsPanel.visible = false

func _on_resume_button_pressed() -> void:
	print("Resume button pressed")
	emit_signal("resume_game")

func _on_restart_button_pressed() -> void:
	print("Restart button pressed")
	emit_signal("restart_game")

func _on_exit_button_pressed() -> void:
	print("Exit button pressed")
	emit_signal("exit_game")

func _on_controls_pressed() -> void:
	# Show the controls panel and hide the main pause menu
	ControlsPanel.visible = true
	$VBoxContainer.visible = false

func _on_back_button_pressed() -> void:
	# Return to the main pause menu and hide the controls panel
	ControlsPanel.visible = false
	$VBoxContainer.visible = true

func _on_volume_slider_changed(value: float) -> void:
	# Convert slider value (0.0 to 1.0) to decibels (-80.0 to 0.0)
	var db_volume = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(AudioBus), db_volume)

# Convert a linear value (0.0 to 1.0) to decibels (-80.0 to 0.0)
func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0  # Mute
	return -80.0 + (linear * 80.0)

# Convert decibels (-80.0 to 0.0) to a linear value (0.0 to 1.0)
func db_to_linear(db: float) -> float:
	if db <= -80.0:
		return 0.0  # Mute
	return (db + 80.0) / 80.0
