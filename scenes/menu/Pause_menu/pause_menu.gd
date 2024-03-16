extends CanvasLayer

@onready var allButtons = %VBoxContainer


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and Global.TalkingWithNPC == false:
		gamePause()

func _on_depause_pressed():
	Global.gameStatus = "Start"
	allButtons.visible = false

func _on_options_pressed():
	get_node("../Options_menu").visible = true
	

func _on_restart_pressed():
	Global.restartGame()

func _on_menu_button_pressed():
	Global.menuButton()

func gamePause():
	if Global.gameStatus != "Over" and Global.gameStatus != "Launch":
		if Global.gameStatus == "Start":
			Global.gameStatus = "Pause"
			allButtons.visible = true
		else:
			Global.gameStatus = "Start"
			allButtons.visible = false
