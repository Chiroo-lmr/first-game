extends Node2D

var playerCurrentAttack = false
var currentScene = "world" #cliffSide #cliffSide2
var transitionScene = false
var enemyKilled = 0

var killed_enemies = []  # Ajout de la liste des ennemis tués

var playerCurrentPosition = Vector2(0, 0)

func add_killed_enemy(enemy_id):
	killed_enemies.append(enemy_id)
	print(killed_enemies)
	
func is_enemy_killed(enemy_id):
	return enemy_id in killed_enemies
