extends Control

func _on_check_button_toggled(toggled_on):
	if toggled_on == true:
		Main.cameraSmoothing = true
	else:
		Main.cameraSmoothing = false

func _process(delta):
	if Main.cameraSmoothing == true:
		$HBoxContainer/CheckButton.button_pressed = true
	else:
		$HBoxContainer/CheckButton.button_pressed = false
