extends Node2D
var Slime1
var Slime2
var Slime3
var Slime4
var slime_boss = null
var countSpawnBoss = 0
var countSpawnNPC = 0

func _ready():
	%player.position = Vector2(272, 120)
	Main.currentDirection = "down"
	Main.playerHealth = 100
	spawnEnemies()
	%WorldCamera.zoom = Vector2(Main.cameraZoom, Main.cameraZoom)
	if Main.cameraPosition == Vector2(10, 15): %WorldCamera.position = Main.cameraPosition
	if Main.cameraPosition == Vector2(471, 180): %WorldCamera.position = Main.cameraPosition
	if Main.cameraPosition == Vector2(272, 120): %WorldCamera.position = Main.cameraPosition

func _process(delta):
	print(Main.currentScene)
	if Slime1 == null:
		if 1 not in Main.killed_enemies:
			Main.addKilledEnemies(1)
	if Slime2 == null:
		if 2 not in Main.killed_enemies:
			Main.addKilledEnemies(2)
	if Slime3 == null:
		if 3 not in Main.killed_enemies:
			Main.addKilledEnemies(3)
	if Slime4 == null:
		if 4 not in Main.killed_enemies:
			Main.addKilledEnemies(4)
	if Main.saidAllSlimesGones:
		spawn_boss()
		spawn_npc()

func spawn_boss():
	if countSpawnBoss == 0:
		var SlimeScene = preload("res://scenes/character/slime/Slime.tscn")
		slime_boss = SlimeScene.instantiate()
		slime_boss.position = Vector2(-235, 120)
		add_child(slime_boss)
		print("boss created")
		#we set some things so it looks like a real boss and not a normal slime
		#slime_boss.apply_knockback = func(): return # it removes the knockback
		slime_boss.health *= 4 # we give it extra life
		slime_boss.scale.x *= 3
		slime_boss.scale.y *= 3
		countSpawnBoss = 1

func spawn_npc():
	if countSpawnNPC == 0:
		var NPCScene = preload("res://scenes/character/npcs/SlimeThatPray.tscn")
		var NPC = NPCScene.instantiate()
		add_child(NPC)
		print("NPC spawned")
		NPC.position = Vector2(-25, 176)
		countSpawnNPC = 1

func _on_cliff_side_transition_point_body_entered(body):
	if body.has_method("player"):
		Main.transitionScene = true
		Main.cameraPosition = Vector2(10, 15)
		if Main.currentScene == "Beginning":
			Main.currentScene = "PrayingTree"
			$player.position = Vector2(-8, Main.playerLivePosition.y)
			$WorldCamera.limit_left = -1664
			#var tweenCamera = get_tree().create_tween()
			#tweenCamera.tween_property($WorldCamera, "position", Vector2(-200, 0), 2)
			#await tweenCamera.finished
			$WorldCamera.limit_right = 0
		elif Main.currentScene == "PrayingTree":
			Main.currentScene = "Beginning"
			$player.position = Vector2(10, Main.playerLivePosition.y)
			$WorldCamera.limit_left = 0
			#var tweenCamera = get_tree().create_tween()
			#tweenCamera.tween_property($WorldCamera, "position", Vector2(0, 0), 2)
			#await tweenCamera.finished
			$WorldCamera.limit_right = 1920

func _on_cliff_side_transition_point_body_exited(body):
	if body.has_method("player"):
		Main.transitionScene = false

func _on_cliff_side_2_transition_point_body_entered(body):
	if body.has_method("player"):
		Main.transitionScene = true
		Main.cameraPosition = Vector2(10, 15)
		if Main.currentScene == "Beginning":
			Main.currentScene = "NPCBedroomBeginning"
			$player.position = Vector2(490, Main.playerLivePosition.y)
			$WorldCamera.limit_left = 1920
			#var tweenCamera = get_tree().create_tween()
			#tweenCamera.tween_property($WorldCamera, "position", Vector2(-200, 0), 2)
			#await tweenCamera.finished
			$WorldCamera.limit_right = 3840
		elif Main.currentScene == "NPCBedroomBeginning":
			Main.currentScene = "Beginning"
			$player.position = Vector2(470, Main.playerLivePosition.y)
			$WorldCamera.limit_left = 0
			#var tweenCamera = get_tree().create_tween()
			#tweenCamera.tween_property($WorldCamera, "position", Vector2(0, 0), 2)
			#await tweenCamera.finished
			$WorldCamera.limit_right = 1920

func _on_cliff_side_2_transition_point_body_exited(body):
	if body.has_method("player"):
		Main.transitionScene = false

func spawnEnemies():
	var SlimeScene = preload("res://scenes/character/slime/Slime.tscn")
	if 1 not in Main.killed_enemies:
		Slime1 = SlimeScene.instantiate()
		Slime1.position = Main.SlimeID[0][1]
		add_child(Slime1)
		if 1 not in Main.SlimeID[0]:
			Main.SlimeID[0][0] = 1
	if 2 not in Main.killed_enemies:
		Slime2 = SlimeScene.instantiate()
		Slime2.position = Main.SlimeID[1][1]
		add_child(Slime2)
		if 2 not in Main.SlimeID[1]:
			Main.SlimeID[1][0] = 2
	if 3 not in Main.killed_enemies:
		Slime3 = SlimeScene.instantiate()
		Slime3.position = Main.SlimeID[2][1]
		add_child(Slime3)
		if 3 not in Main.SlimeID[2]:
			Main.SlimeID[2][0] = 3
	if 4 not in Main.killed_enemies:
		Slime4 = SlimeScene.instantiate()
		Slime4.position = Main.SlimeID[3][1]
		add_child(Slime4)
		if 4 not in Main.SlimeID[3]:
			Main.SlimeID[3][0] = 4






