extends Node2D

func _ready():
	if Global.playerCurrentPosition == Vector2(471, 265):
		$player.position = Global.playerCurrentPosition
	elif Global.playerCurrentPosition == Vector2(30, 26):
		$player.position = Global.playerCurrentPosition
	else:
		$player.position = Vector2(272,120)
	spawnEnemies()
	
	
	
func _on_cliff_side_transition_point_body_entered(body):
	if body.has_method("player"):
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
		Global.currentScene = "cliffSide"


func _on_cliff_side_transition_point_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false

#func ChangeScene():
	#if Global.transitionScene == true:
			#get_tree().change_scene_to_file("res://scenes/ciff_side.tscn")
			#Global.gameFirstLoaded = false
			#Global.currentScene = "cliffSide"


func _on_cliff_side_2_transition_point_body_entered(body):
	if body.has_method("player"):
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/cliff_side_2.tscn")
		Global.currentScene = "cliffSide2"
	
func _on_cliff_side_2_transition_point_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false

func spawnEnemies():
	var enemyScene = preload("res://scenes/enemy.tscn")
	if 1 not in Global.killed_enemies:
		var enemy1 = enemyScene.instantiate()
		enemy1.position = Vector2(randi_range(220, 250), randi_range(60, 90))
		add_child(enemy1)
		if 1 not in Global.howManyEnemies:
			Global.addEnemy(1)
	if 2 not in Global.killed_enemies:
		var enemy2 = enemyScene.instantiate()
		enemy2.position = Vector2(randi_range(430, 470), randi_range(90, 110))
		add_child(enemy2)
		if 2 not in Global.howManyEnemies:
			Global.addEnemy(2)
	if 3 not in Global.killed_enemies:
		var enemy3 = enemyScene.instantiate()
		enemy3.position = Vector2(randi_range(40, 70), randi_range(100, 140))
		add_child(enemy3)
		if 3 not in Global.howManyEnemies:
			Global.addEnemy(3)
	if 4 not in Global.killed_enemies:
		var enemy4 = enemyScene.instantiate()
		enemy4.position = Vector2(randi_range(140, 170), randi_range(180, 210))
		add_child(enemy4)
		if 4 not in Global.howManyEnemies:
			Global.addEnemy(4)











