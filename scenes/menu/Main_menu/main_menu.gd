extends Control

@onready var startButton = %Play
@onready var QuitButton = %Quit
@onready var options = %Options
@onready var creditsLabel = %Credits
var creditsOpened = false
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Maps/beginningScene/Beginning.tscn")
	Global.gameStatus = "Start"

func _on_options_pressed():
	$Options_menu.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	if creditsOpened == false:
		creditsLabel.visible = true
		creditsOpened = true
	else:
		creditsLabel.visible = false
		creditsOpened = false
