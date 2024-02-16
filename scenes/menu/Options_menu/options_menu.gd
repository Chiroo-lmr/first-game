extends CanvasLayer

func _process(delta):
	if Global.gameLaunch == true:
		%Main_menuButton.visible = true
		%backToGameButton.visible = false
	elif Global.gamePause == true:
		%Main_menuButton.visible = false
		%backToGameButton.visible = true
func _on_main_menu_button_pressed():
	visible = false

func _on_back_to_game_button_pressed():
	visible = false
	
