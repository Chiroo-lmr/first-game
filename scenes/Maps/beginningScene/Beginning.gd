extends Node2D
var Slime1
var Slime2
var Slime3
var Slime4

func _ready():
	$player.position = Global.playerLivePosition
	spawnEnemies()
	$WorldCamera.position = Vector2(272, 120)
	$WorldCamera.zoom = Vector2(1.25, 1.25)
	if Global.cameraPosition == Vector2(0, 0): $WorldCamera.position = Global.cameraPosition
	if Global.cameraPosition == Vector2(480, 272): $WorldCamera.position = Global.cameraPosition
	
func _process(delta):
	if Slime1 == null:
		if 1 not in Global.killed_enemies:
			Global.addKilledEnemies(1)
	if Slime2 == null:
		if 2 not in Global.killed_enemies:
			Global.addKilledEnemies(2)
	if Slime3 == null:
		if 3 not in Global.killed_enemies:
			Global.addKilledEnemies(3)
	if Slime4 == null:
		if 4 not in Global.killed_enemies:
			Global.addKilledEnemies(4)

func _on_cliff_side_transition_point_body_entered(body):
	if body.has_method("player"):
		if Slime1  != null:
			Global.SlimeID[0][1] = Slime1.position
		if Slime2  != null:
			Global.SlimeID[1][1] = Slime2.position
		if Slime3  != null:
			Global.SlimeID[2][1] = Slime3.position
		if Slime4  != null:
			Global.SlimeID[3][1] = Slime4.position
		$WorldCamera.position = Vector2(0, 0)
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/Maps/PrayingTree/PrayingTree.tscn")
		Global.currentScene = "PrayingTree"


func _on_cliff_side_transition_point_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false

func _on_cliff_side_2_transition_point_body_entered(body):
	if body.has_method("player"):
		if Slime1  != null:
			Global.SlimeID[0][1] = Slime1.position
		if Slime2  != null:
			Global.SlimeID[1][1] = Slime2.position
		if Slime3  != null:
			Global.SlimeID[2][1] = Slime3.position
		if Slime4  != null:
			Global.SlimeID[3][1] = Slime4.position
		$WorldCamera.position = Vector2(480, 272)
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/Maps/NPCBedroomBeginning/NPCBedroomBeginning.tscn")
		Global.currentScene = "NPCBedroomBeginning"
		
	
func _on_cliff_side_2_transition_point_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false

func spawnEnemies():
	var SlimeScene = preload("res://scenes/character/slime/Slime.tscn")
	if 1 not in Global.killed_enemies:
		Slime1 = SlimeScene.instantiate()
		Slime1.position = Global.SlimeID[0][1]
		add_child(Slime1)
		if 1 not in Global.SlimeID[0]:
			Global.SlimeID[0][0] = 1
	if 2 not in Global.killed_enemies:
		Slime2 = SlimeScene.instantiate()
		Slime2.position = Global.SlimeID[1][1]
		add_child(Slime2)
		if 2 not in Global.SlimeID[1]:
			Global.SlimeID[1][0] = 2
	if 3 not in Global.killed_enemies:
		Slime3 = SlimeScene.instantiate()
		Slime3.position = Global.SlimeID[2][1]
		add_child(Slime3)
		if 3 not in Global.SlimeID[2]:
			Global.SlimeID[2][0] = 3
	if 4 not in Global.killed_enemies:
		Slime4 = SlimeScene.instantiate()
		Slime4.position = Global.SlimeID[3][1]
		add_child(Slime4)
		if 4 not in Global.SlimeID[3]:
			Global.SlimeID[3][0] = 4






