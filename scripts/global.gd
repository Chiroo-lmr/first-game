extends Node2D

var playerCurrentAttack = false
var currentScene = "world" #cliffSide #cliffSide2
var transitionScene = false
var playerHealth = 100

var killed_enemies = [] 
var howManyEnemies = [randf(), randf(), randf(), randf()]
var enemiesKilled = 0
var allSlimesGone = false
var saidAllSlimesGones = false
var labelScore = 0
var label = 0
var playerCurrentPosition = Vector2(0, 0)

var gameOver = false
var gameStart = false
var gamePause = false
@onready var QuitButton
@onready var restartButton
@onready var depauseButton

func _ready():
	print(howManyEnemies)

func addEnemy(enemy_id):
	howManyEnemies.append(enemy_id)
	print(howManyEnemies)

func addKilledEnemies(enemy_id):
	killed_enemies.append(enemy_id)
	print(killed_enemies)
	print(enemiesKilled)
	
func _physics_process(delta):
	if !Input.is_action_just_pressed("attack"):
		playerCurrentAttack = false
	if enemiesKilled == 4:
		allSlimesGone = true
	print(allSlimesGone)
	if label == 1:
		labelScore.visible = true


