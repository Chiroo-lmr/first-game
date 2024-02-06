extends CanvasLayer

@onready var labelScore = $Score
@onready var labelGameOver = $gameOver
@onready var startButton = $startButton
func restart_game():
	var scene_path = "res://scenes/World.tscn"
	var scene_instance = load(scene_path)
func _on_start_button_pressed():
	Global.gameStart = true
	startButton.visible = false
	Global.gameLaunch = false
@onready var QuitButton = $QuitButton
func _on_quit_button_pressed():
	get_tree().quit()
@onready var restartButton = $RestartButton
func _on_restart_button_pressed():
	Global.gameStart = true
	Global.gamePause = false
	Global.gameOver = false
	Global.killed_enemies = [] 
	Global.howManyEnemies = []
	Global.enemiesKilled = 0
	Global.allSlimesGone = false
	Global.playerHealth = 100
	Global.playerCurrentPosition = Vector2(272, 120)
	Global.allSlimesGone = false
	Global.saidAllSlimesGones = false
	Global.interacted_once = false
	Global.labelScore = 0
	Global.label = 0
	get_tree().reload_current_scene()
@onready var depauseButton = $depauseButton
func _on_depause_button_pressed():
	Global.gameStart = true
	Global.gamePause = false
	QuitButton.visible = false
	depauseButton.visible = false
	restartButton.visible = false

func _ready():
	Global.labelScore = labelScore
	
func _physics_process(delta):
	labelScore.text = "Ennemis tués : " + str(Global.enemiesKilled)
	labelGameOver.visible = false
	if Global.gameOver == true:
		Global.gameStart = false
		Global.gamePause = false
		Global.gameLaunch == false
		restartButton.visible = true
		labelGameOver.visible = true
		QuitButton.visible = true
		print(Global.gameStart)
	if Global.gameStart == true:
		Global.gameOver = false
		Global.gamePause = false
		Global.gameLaunch == false
		startButton.visible = false
		print(Global.gameStart)
	if Global.gameLaunch == true:
		startButton.visible = true
		print(Global.gameStart)
	if Input.is_action_just_pressed("ui_cancel"):
		game_pause()
		print(Global.gameStart)
	if Global.label == 0:
		labelScore.visible = false

func game_pause():
	if Global.gameStart == true:
		Global.gameStart = false
		Global.gamePause = true
		QuitButton.visible = true
		restartButton.visible = true
		depauseButton.visible = true
	else:
		Global.gameStart = true
		Global.gamePause = false
		QuitButton.visible = false
		restartButton.visible = false
		depauseButton.visible = false
