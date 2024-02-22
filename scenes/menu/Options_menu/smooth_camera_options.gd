extends Control

func _on_check_button_toggled(toggled_on):
	if toggled_on == true:
		Global.cameraSmoothing = true
	else:
		Global.cameraSmoothing = false

func _process(delta):
	if Global.cameraSmoothing == true:
		$HBoxContainer/CheckButton.button_pressed = true
	else:
		$HBoxContainer/CheckButton.button_pressed = false
