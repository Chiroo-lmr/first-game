extends Control

@onready var option_button = $HBoxContainer/OptionButton
var screenSizeX = DisplayServer.window_get_size().x
var screenSizeY = DisplayServer.window_get_size().y
var oneTime0 = 0
var RESOLUTION_DICTIONARY : Dictionary = {
"1920 x 1080" : Vector2i(1920, 1080),
"1920 x 1200" : Vector2i(1920, 1200),
"1280 x 720" : Vector2i(1280, 720),
"1152 x 648" : Vector2i(1152, 648),
"2560 x 1600" : Vector2i(2560, 1600),
"actual" : Vector2i(0, 0)
}

func _ready():
	add_resolution_items()

func _process(delta):
	var targetResolution = str(screenSizeX) + " x " + str(screenSizeY)
	screenSizeX = DisplayServer.window_get_size().x
	screenSizeY = DisplayServer.window_get_size().y
	if targetResolution not in RESOLUTION_DICTIONARY:
		print("ca ny est pas")
		if oneTime0 == 0:
			option_button.add_item(targetResolution)
			option_button.select(5)
			oneTime0+=1
		option_button.set_item_text(5, targetResolution)
	else:
		option_button.remove_item(5)
	var resolutionDictionary = RESOLUTION_DICTIONARY
	var index = -1  # Initialisation à -1 pour indiquer que la condition n'a pas été vérifiée
	# Parcourez le dictionnaire pour trouver l'indice de la condition vérifiée		
	for resolution_size_text in resolutionDictionary:
		index += 1
		if resolution_size_text == targetResolution:
			option_button.select(index)
			break  # Sortez de la boucle une fois que la condition est vérifiée

func add_resolution_items():
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)

func _on_option_button_item_selected(index):
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
