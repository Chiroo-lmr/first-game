extends Node2D

var playerCurrentAttack = false
var playerHealth = 100
var playerLivePosition = Vector2(272,120)
var player : Node2D
var playerCanAttack = true
var currentDirection = "none" # utilisé pour les animations 
var not_red_at = 0 # utilisé pour rendre le player rouge quand attaqué 

var killed_enemies = [] 
var enemiesKilled = 0
var SlimeID = [[0, Vector2(randi_range(200, 220), randi_range(40, 60))], [0, Vector2(randi_range(430, 470), randi_range(90, 110))], [0, Vector2(randi_range(40, 70), randi_range(100, 140))], [0, Vector2(randi_range(140, 170), randi_range(180, 210))]]
var SlimePosition = []
var enemyIsAttacking = false

var currentScene = "Beginning"
var transitionScene = false

var allSlimesGone = false
var saidAllSlimesGones = false
var interacted_once = false
var TalkingWithNPC = false

var cameraPosition = Vector2(272, 120)
var cameraSmoothing = true
var cameraZoom = 1.25

var label = 0
@onready var QuitButton
@onready var restartButton
@onready var depauseButton

var gameLaunch = true
var gameOver = false
var gameStart = false
var gamePause = false
var gameTab = false
var checkIfRestartFinish = false

func _ready():
	pass
	
func addSlime(Slime_id):
	SlimeID.append(Slime_id)

func addKilledEnemies(enemy_id):
	killed_enemies.append(enemy_id)
	enemiesKilled += 1
	
func getSlimePosition(currentPosition):
	SlimeID.append(currentPosition)
	
func _physics_process(delta):
	if !Input.is_action_just_pressed("attack"):
		playerCurrentAttack = false
	else:
		playerCurrentAttack = true
	if enemiesKilled == 4:
		allSlimesGone = true
	if gameOver == true:
		gameStart = false
		gamePause = false
		gameLaunch = false
		gameTab = false
	if gameStart == true:
		gameOver = false
		gamePause = false
		gameLaunch = false
	
	
func restartGame():
	gameStart = true
	gamePause = false
	gameOver = false
	killed_enemies = [] 
	enemiesKilled = 0
	SlimeID = [[0, Vector2(randi_range(200, 220), randi_range(40, 60))], [0, Vector2(randi_range(430, 470), randi_range(90, 110))], [0, Vector2(randi_range(40, 70), randi_range(100, 140))], [0, Vector2(randi_range(140, 170), randi_range(180, 210))]]
	allSlimesGone = false
	playerHealth = 100
	playerLivePosition = Vector2(272, 120)
	allSlimesGone = false
	saidAllSlimesGones = false
	interacted_once = false
	TalkingWithNPC = false
	label = 0
	cameraPosition = Vector2(272, 120)
	get_tree().reload_current_scene()
	checkIfRestartFinish = true

func menuButton():
	restartGame()
	if checkIfRestartFinish == true:
		get_tree().change_scene_to_file("res://scenes/menu/Main_menu/main_menu.tscn")
	Global.gameLaunch = true
	Global.gameStart = false
	
