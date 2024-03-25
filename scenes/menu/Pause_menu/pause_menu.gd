extends CanvasLayer

@onready var allButtons = %VBoxContainer


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and Main.TalkingWithNPC == false:
		gamePause()

func _on_depause_pressed():
	Main.gameStatus = "Start"
	allButtons.visible = false

func _on_options_pressed():
	get_node("../Options_menu").visible = true

func _on_restart_pressed():
	Main.restartGame()
	visible = false

func _on_menu_button_pressed():
	Main.menuButton()
	visible = false

func gamePause():
	if Main.gameStatus != "Over" and Main.gameStatus != "Launch":
		if Main.gameStatus == "Start":
			Main.gameStatus = "Pause"
			visible = true
			allButtons.visible = true
		else:
			Main.gameStatus = "Start"
			allButtons.visible = false
			visible = false
