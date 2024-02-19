extends CanvasLayer

@onready var allButtons = %VBoxContainer


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and Global.TalkingWithNPC == false:
		gamePause()

func _on_depause_pressed():
	Global.gameStart = true
	Global.gamePause = false
	allButtons.visible = false
	Global.reginTimerPlayer.paused = false

func _on_options_pressed():
	get_node("../Options_menu").visible = true
	

func _on_restart_pressed():
	Global.restartGame()

func _on_menu_button_pressed():
	Global.menuButton()

func gamePause():
	if Global.gameOver == false and Global.gameLaunch == false:
		if Global.gameStart == true:
			Global.gameStart = false
			Global.gamePause = true
			Global.gameTab = false
			allButtons.visible = true
		else:
			Global.gameStart = true
			Global.gamePause = false
			allButtons.visible = false
