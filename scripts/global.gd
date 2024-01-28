extends Node2D

var playerCurrentAttack = false
var currentScene = "world" #cliffSide #cliffSide2
var transitionScene = false

var killed_enemies = []  # Ajout de la liste des ennemis tués
var howManyEnemies = []

var playerCurrentPosition = Vector2(0, 0)

func addEnemy(enemy_id):
	howManyEnemies.append(enemy_id)
	print(howManyEnemies)

func addKilledEnemies(enemy_id):
	killed_enemies.append(enemy_id)
