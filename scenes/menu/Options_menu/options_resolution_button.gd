extends Control

@onready var option_button = $HBoxContainer/OptionButton

const RESOLUTION_DICTIONNARY : Dictionary = {
"1920 x 1080" : Vector2i(1920, 1080),
"1920 x 1200" : Vector2i(1920, 1200),
"1280 x 720" : Vector2i(1280, 720),
"1152 x 648" : Vector2i(1152, 648),
}

func _ready():
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_items()
	
func add_resolution_items():
	for resolution_size_text in RESOLUTION_DICTIONNARY:
		option_button.add_item(resolution_size_text)


func on_resolution_selected(index):
	DisplayServer.window_set_size(RESOLUTION_DICTIONNARY.values()[index])
