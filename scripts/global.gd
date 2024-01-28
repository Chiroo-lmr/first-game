extends Node2D

var playerCurrentAttack = false
var currentScene = "world" #cliffSide #cliffSide2
var transitionScene = false
var playerHealth = 100

var killed_enemies = []  # Ajout de la liste des ennemis tués
var howManyEnemies = []
var enemiesKilled = 0

var playerCurrentPosition = Vector2(0, 0)

var buttonPressed = false
var gameOver = false
var gameStart = false
var gamePause = false
@onready var QuitButton
@onready var restartButton

func addEnemy(enemy_id):
	howManyEnemies.append(enemy_id)
	print(howManyEnemies)

func addKilledEnemies(enemy_id):
	killed_enemies.append(enemy_id)

func _physics_process(delta):
	if buttonPressed == true:
		gameStart = true
	if !Input.is_action_just_pressed("attack"):
		playerCurrentAttack = false
	if Input.is_action_pressed("ui_cancel"):
		if gameStart == true:
			gamePause = true
			QuitButton.visible = true
			restartButton.visible = true



