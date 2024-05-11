extends CanvasLayer

@onready var startButton = %Play
@onready var QuitButton = %Quit
@onready var options = %Options
@onready var creditsLabel = %Credits
var creditsOpened = false

func _on_play_pressed():
	visible = false
	var world = preload("res://scenes/Maps/beginningScene/Beginning.tscn").instantiate()
	world.name = "World"
	get_parent().add_child(world)
	#remove_child(get_parent().get_node("World/slime_boss"))
	#remove_child(get_parent().get_node("World/NPC2"))
	get_parent().get_node("World").visible = true
	Main.gameStatus = "Start"

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
