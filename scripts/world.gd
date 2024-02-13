extends Node2D
var enemy1
var enemy2
var enemy3
var enemy4

func _ready():
	if Global.playerCurrentPosition == Vector2(471, 265):
		$player.position = Global.playerCurrentPosition
	elif Global.playerCurrentPosition == Vector2(30, 26):
		$player.position = Global.playerCurrentPosition
	else:
		$player.position = Vector2(272,120)
	spawnEnemies()
	$WorldCamera.position = Vector2(272, 120)
	$WorldCamera.zoom = Vector2(1.25, 1.25)
	if Global.cameraPosition == Vector2(0, 0): $WorldCamera.position = Global.cameraPosition
	if Global.cameraPosition == Vector2(480, 272): $WorldCamera.position = Global.cameraPosition
	
func _process(delta):
	if enemy1 == null:
		if 1 not in Global.killed_enemies:
			Global.addKilledEnemies(1)
	if enemy2 == null:
		if 2 not in Global.killed_enemies:
			Global.addKilledEnemies(2)
	if enemy3 == null:
		if 3 not in Global.killed_enemies:
			Global.addKilledEnemies(3)
	if enemy4 == null:
		if 4 not in Global.killed_enemies:
			Global.addKilledEnemies(4)

func _on_cliff_side_transition_point_body_entered(body):
	if body.has_method("player"):
		if enemy1  != null:
			Global.SlimeID[0][1] = enemy1.position
		if enemy2  != null:
			Global.SlimeID[1][1] = enemy2.position
		if enemy3  != null:
			Global.SlimeID[2][1] = enemy3.position
		if enemy4  != null:
			Global.SlimeID[3][1] = enemy4.position
		$WorldCamera.position = Vector2(0, 0)
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
		Global.currentScene = "cliffSide"


func _on_cliff_side_transition_point_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false

func _on_cliff_side_2_transition_point_body_entered(body):
	if body.has_method("player"):
		if enemy1  != null:
			Global.SlimeID[0][1] = enemy1.position
		if enemy2  != null:
			Global.SlimeID[1][1] = enemy2.position
		if enemy3  != null:
			Global.SlimeID[2][1] = enemy3.position
		if enemy4  != null:
			Global.SlimeID[3][1] = enemy4.position
		$WorldCamera.position = Vector2(480, 272)
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/cliff_side_2.tscn")
		Global.currentScene = "cliffSide2"
		
	
func _on_cliff_side_2_transition_point_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false

func spawnEnemies():
	var enemyScene = preload("res://scenes/enemy.tscn")
	if 1 not in Global.killed_enemies:
		enemy1 = enemyScene.instantiate()
		enemy1.position = Global.SlimeID[0][1]
		add_child(enemy1)
		if 1 not in Global.SlimeID[0]:
			Global.SlimeID[0][0] = 1
	if 2 not in Global.killed_enemies:
		enemy2 = enemyScene.instantiate()
		enemy2.position = Global.SlimeID[1][1]
		add_child(enemy2)
		if 2 not in Global.SlimeID[1]:
			Global.SlimeID[1][0] = 2
	if 3 not in Global.killed_enemies:
		enemy3 = enemyScene.instantiate()
		enemy3.position = Global.SlimeID[2][1]
		add_child(enemy3)
		if 3 not in Global.SlimeID[2]:
			Global.SlimeID[2][0] = 3
	if 4 not in Global.killed_enemies:
		enemy4 = enemyScene.instantiate()
		enemy4.position = Global.SlimeID[3][1]
		add_child(enemy4)
		if 4 not in Global.SlimeID[3]:
			Global.SlimeID[3][0] = 4






