extends CanvasLayer
var animPlayedOnce = false
var tweenOpacityGameOver
var tweenRestart
var tweenMenu

func _process(delta):
	if Main.ButtonsGameOver == true:
		if animPlayedOnce == false:
			animPlayedOnce = true
			$AudioStreamPlayer.playing = true
			tweenOpacityGameOver = get_tree().create_tween()
			visible = true
			%VBoxContainer.visible = true
			%GameOver.visible = true
			tweenOpacityGameOver.tween_property(%GameOver, "modulate:a", 1, 2)
			await tweenOpacityGameOver.finished
			%Restart.visible = true
			tweenRestart = get_tree().create_tween()
			tweenRestart.tween_property(%Restart, "modulate:a", 1, 1)
			%menuButton.visible = true
			tweenMenu = get_tree().create_tween()
			tweenMenu.tween_property(%menuButton, "modulate:a", 1, 1)

func _on_restart_pressed():
	Main.restartGame()
	$AudioStreamPlayer.playing = false
	get_parent().get_node("MusicStreamPlayer").playing = true
	visible = false
	animPlayedOnce = false
	tweenOpacityGameOver = null
	var tweenRestart = null
	var tweenMenu = null

func _on_menu_button_pressed():
	Main.menuButton()
	$AudioStreamPlayer.playing = false
	get_parent().get_node("MusicStreamPlayer").playing = true
	visible = false
	animPlayedOnce = false
	tweenOpacityGameOver = null
