extends Control

@onready var fullscreen = $HBoxContainer/fullscreen

func _on_fullscreen_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(DisplayServer.window_get_size().x, DisplayServer.window_get_size().y - 5 ))


func _process(delta):
	if DisplayServer.window_get_mode() == 3:
		$"../Options_Resolution_Button".visible = false
		fullscreen.button_pressed = true
	else:
		$"../Options_Resolution_Button".visible = true
		fullscreen.button_pressed = false
