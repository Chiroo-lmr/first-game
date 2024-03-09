extends Control

@onready var audio_name_lbl = $HBoxContainer/Audio_name_lbl
@onready var h_slider = $HBoxContainer/HSlider
@onready var audio_num_lbl = $HBoxContainer/Audio_num_lbl

@export_range(0, 2) var bus_index : int
var bus_name : String

func _process(delta):
	match bus_index:
		0: 
			bus_name = "Master"
		1: 
			bus_name = "Music"
		2: 
			bus_name = "Sfx"

	set_name_label()
	set_slider_value()

func set_name_label():
	audio_name_lbl.text = str(bus_name) + " Volume"

func set_num_label():
	audio_num_lbl.text = str(h_slider.value * 100) + " %"

func set_slider_value():
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_num_label()
	
func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_num_label()
