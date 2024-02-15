extends CanvasLayer

@onready var allButtons = %VBoxContainer


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		gamePause()

func _on_depause_pressed():
	Global.gameStart = true
	Global.gamePause = false
	allButtons.visible = false
	Global.reginTimerPlayer.paused = false

func _on_options_pressed():
	pass # Replace with function body.

func _on_restart_pressed():
	Global.restartGame()

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/Main_menu/main_menu.tscn")

func gamePause():
	if Global.gameOver == false and Global.gameLaunch == false:
		if Global.gameStart == true:
			Global.gameStart = false
			Global.gamePause = true
			Global.gameTab = false
			allButtons.visible = true
			Global.reginTimerPlayer.paused = true
		else:
			Global.gameStart = true
			Global.gamePause = false
			allButtons.visible = false
			Global.reginTimerPlayer.paused = false
