extends Control

@onready var h_slider = $HBoxContainer/HSlider
@onready var zoom_value = $HBoxContainer/ZoomValue

func _on_h_slider_value_changed(value):
	zoom_value.text = str(value) + "x"
	Main.cameraZoom = value
	h_slider.value = Main.cameraZoom
	
func _process(delta):
	h_slider.value = Main.cameraZoom
