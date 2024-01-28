extends CanvasLayer

func _ready():
	$startButton.visible = true

func _physics_process(delta):
	$Score.text = "Ennemis tués : " + str(Global.enemiesKilled)
	Global.restartButton = $RestartButton
	Global.QuitButton = $QuitButton
	$gameOver.visible = false
	if Global.gameOver == true:
		$RestartButton.visible = true
		$gameOver.visible = true
		$QuitButton.visible = true
	if Global.gameStart == true:
		$startButton.visible = false
	
	
func _on_start_button_pressed():
	Global.buttonPressed = true
	$startButton.visible = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_escape_restart_button_pressed():
	Global.gameStart = true
	Global.gamePause = false
	Global.gameOver = false
	Global.killed_enemies = []
	Global.howManyEnemies = []
	Global.enemiesKilled = 0
	Global.playerHealth = 100
	get_tree().reload_current_scene()
