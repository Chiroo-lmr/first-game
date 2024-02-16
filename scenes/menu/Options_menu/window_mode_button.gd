extends Control

@onready var option_button = $HBoxContainer/OptionButton

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Window-mode",
	"Borderless_Window-Mode",
	"Borderless_Full-Screen"
]

func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)
func add_window_mode_items():
	for window_mode in WINDOW_MODE_ARRAY: 
		option_button.add_item(window_mode)

func _process(delta):
	if DisplayServer.window_get_mode() == 3:
		$"../Options_Resolution_Button".visible = false
	else:
		$"../Options_Resolution_Button".visible = true



func on_window_mode_selected(index):
	match index:
		0: # fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # b window mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # b fullscreen 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
