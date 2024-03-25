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

var gameStatus = "Launch"
var gameTab = false
var checkIfRestartFinish = false
var is_restarting = false
var is_menu_pressed = false
var ButtonsGameOver = false

func addSlime(Slime_id):
	SlimeID.append(Slime_id)

func addKilledEnemies(enemy_id):
	killed_enemies.append(enemy_id)
	enemiesKilled += 1

func getSlimePosition(currentPosition):
	SlimeID.append(currentPosition)

func _physics_process(delta):
	if enemiesKilled == 4:
		allSlimesGone = true
	print(currentScene)

func resetVar():
	killed_enemies = [] 
	enemiesKilled = 0
	SlimeID = [[0, Vector2(randi_range(200, 220), randi_range(40, 60))], [0, Vector2(randi_range(430, 470), randi_range(90, 110))], [0, Vector2(randi_range(40, 70), randi_range(100, 140))], [0, Vector2(randi_range(140, 170), randi_range(180, 210))]]
	allSlimesGone = false
	saidAllSlimesGones = false
	interacted_once = false
	TalkingWithNPC = false
	playerHealth = 100
	playerLivePosition = Vector2(272, 120)
	label = 0
	cameraPosition = Vector2(272, 120)
	ButtonsGameOver = false

func restartGame():
	resetVar()
	is_restarting = true
	gameStatus = "Start"

func menuButton():
	resetVar()
	is_menu_pressed = true
	gameStatus = "Launch"
	
