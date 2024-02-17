extends Control
var resolutionx = DisplayServer.window_get_size().x
var resolutiony = DisplayServer.window_get_size().y
var resolutionText = str(resolutionx) + " x " + str(resolutiony)

func _process(delta):
	resolutionx = DisplayServer.window_get_size().x
	resolutiony = DisplayServer.window_get_size().y
	resolutionText = str(resolutionx) + " x " + str(resolutiony)
	$HBoxContainer/Label2.text = resolutionText
