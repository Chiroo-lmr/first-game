extends CanvasLayer

@onready var labelScore = $Score
@onready var labelGameOver = $gameOver
@onready var startButton = $startButton
@onready var HealthBar = $HealthBar
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
	if Global.gameStart == true:
		Global.gameOver = false
		Global.gamePause = false
		Global.gameLaunch = false
		startButton.visible = false
	if Global.gameLaunch == true:
		startButton.visible = true
	if Input.is_action_just_pressed("ui_cancel"):
		game_pause()
	if Global.label == 0:
		labelScore.visible = false
	updateHealth()

func game_pause():
	if Global.gameOver == false and Global.gameLaunch == false:
		if Global.gameStart == true:
			Global.gameStart = false
			Global.gamePause = true
			QuitButton.visible = true
			restartButton.visible = true
			Global.reginTimerPlayer.paused = true
			
		else:
			Global.gameStart = true
			Global.gamePause = false
			QuitButton.visible = false
			restartButton.visible = false
			Global.reginTimerPlayer.paused = false
			Global.reginTimerEnemy.paused = false

func updateHealth():
	HealthBar.value = Global.playerHealth
	if Global.playerHealth >= 100:
		HealthBar.visible = false
	elif Global.playerHealth == 0:
		HealthBar.visible = false
	else:
		HealthBar.visible = true
