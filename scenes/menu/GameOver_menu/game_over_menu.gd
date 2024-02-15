extends CanvasLayer

@onready var allButtonLabel = %VBoxContainer

func _process(delta):
	if Global.playerHealth == 0:
		allButtonLabel.visible = true

func _on_restart_pressed():
	Global.restartGame()

func _on_menu_button_pressed():
	Global.menuButton()
