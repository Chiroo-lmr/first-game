extends CanvasLayer
var animPlayedOnce = false

func _process(delta):
	if Global.ButtonsGameOver == true:
		if animPlayedOnce == false:
			animPlayedOnce = true
			$AudioStreamPlayer.playing = true
			var tweenOpacityGameOver = get_tree().create_tween()
			%VBoxContainer.visible = true
			%GameOver.visible = true
			tweenOpacityGameOver.tween_property(%GameOver, "modulate:a", 1, 2)
			await tweenOpacityGameOver.finished
			%Restart.visible = true
			get_tree().create_tween().tween_property(%Restart, "modulate:a", 1, 1)
			%menuButton.visible = true
			get_tree().create_tween().tween_property(%menuButton, "modulate:a", 1, 1)

func _on_restart_pressed():
	Global.restartGame()
	$AudioStreamPlayer.playing = false

func _on_menu_button_pressed():
	Global.menuButton()
