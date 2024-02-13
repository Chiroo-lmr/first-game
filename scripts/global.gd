extends Node2D

var playerCurrentAttack = false
var currentScene = "world" #cliffSide #cliffSide2
var transitionScene = false
var playerHealth = 100
var killed_enemies = [] 
var enemiesKilled = 0
var SlimeID = [[0, Vector2(randi_range(200, 220), randi_range(40, 60))], [0, Vector2(randi_range(430, 470), randi_range(90, 110))], [0, Vector2(randi_range(40, 70), randi_range(100, 140))], [0, Vector2(randi_range(140, 170), randi_range(180, 210))]]
var SlimePosition = []
var allSlimesGone = false
var saidAllSlimesGones = false
var interacted_once = false
var labelScore = 0
var label = 0
var playerCurrentPosition = Vector2(0, 0)
var reginTimerPlayer
var cameraPosition
var gameLaunch = true
var gameOver = false
var gameStart = false
var gamePause = false
var gameTab = false
@onready var QuitButton
@onready var restartButton
@onready var depauseButton

func _ready():
	pass
	
func addEnemy(enemy_id):
	SlimeID.append(enemy_id)
	print("le/s slime/s : " + str(SlimeID))

func addKilledEnemies(enemy_id):
	killed_enemies.append(enemy_id)
	enemiesKilled += 1
	print("Les slimes tués sont : " + str(killed_enemies))
	print("Le nombre total d'ennemis tués est : " + str(enemiesKilled))
	
func getSlimePosition(currentPosition):
	SlimeID.append(currentPosition)
	print(SlimePosition)
	
func _physics_process(delta):
	if !Input.is_action_just_pressed("attack"):
		playerCurrentAttack = false
	if enemiesKilled == 4:
		allSlimesGone = true
	if label == 1:
		labelScore.visible = true
	


