extends Control

@onready var option_button = $HBoxContainer/OptionButton
var targetResolution
var indexSelect
var RESOLUTION_DICTIONARY : Dictionary = {
"1920 x 1080" : Vector2i(1920, 1080), #0
"1920 x 1020" : Vector2i(1920, 1020), #1
"1280 x 720" : Vector2i(1280, 720), #2
"1152 x 648" : Vector2i(1152, 648), #3
"actual resolution" : Vector2i(DisplayServer.window_get_size().x, DisplayServer.window_get_size().y)
}

func _ready():
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)
	
func _on_option_button_item_selected(index):
	var resolutionToSet
	indexSelect = index
	resolutionToSet = RESOLUTION_DICTIONARY.values()[index]
	DisplayServer.window_set_size(resolutionToSet)
	print("resolution mise : " + str(resolutionToSet) + " resolution actuelle : " + str(DisplayServer.window_get_size()))
	if resolutionToSet != DisplayServer.window_get_size():
		resolutionToSet = DisplayServer.window_get_size()
		RESOLUTION_DICTIONARY.values()[index] = Vector2(DisplayServer.window_get_size().x, DisplayServer.window_get_size().y)
	return index
	
func _process(delta):
	targetResolution = str(DisplayServer.window_get_size().x) + " x " + str(DisplayServer.window_get_size().y)
	if targetResolution not in RESOLUTION_DICTIONARY:
		option_button.set_item_disabled(4, false)
		option_button.select(4)
		option_button.text = targetResolution
	else:
		option_button.set_item_disabled(4, true)
	for resolution_size_text in RESOLUTION_DICTIONARY:
		if resolution_size_text == targetResolution and indexSelect:
			option_button.select(indexSelect)
			break 
