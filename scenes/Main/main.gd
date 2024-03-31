extends Node2D
var world = preload("res://scenes/Maps/beginningScene/Beginning.tscn").instantiate()
var CountMusicBattle = 0
var countSpawnBoss = 0
var slime_boss

func _process(delta):
	HandleBossBattle()
	HandleRestartAndMenu()
	HandleVisibleScenes()

func HandleVisibleScenes():
	if Main.playerHealth <= 0:
		$MusicStreamPlayer.playing = false
	if Main.gameStatus == "Launch":
		if world != null:
			world.visible = false
		$Main_menu.visible = true
	elif Main.gameStatus == "Start":
		if world != null:
			world.visible = true
		$Main_menu.visible = false

func HandleRestartAndMenu():
	if Main.is_restarting == true:
		remove_child($World)
		$Main_menu.visible = false
		world = preload("res://scenes/Maps/beginningScene/Beginning.tscn").instantiate()
		add_child(world)
		remove_child($World/slime_boss)
		remove_child($World/NPC2)
		world.visible = true
		Main.is_restarting = false
	if Main.is_menu_pressed == true:
		$Main_menu.visible = true
		remove_child($World)
		Main.is_menu_pressed = false

func HandleBossBattle():
	if Main.BossfightStarted:
		if CountMusicBattle == 0:
			CountMusicBattle = 1
			var tweenMusic = get_tree().create_tween()
			tweenMusic.tween_property($MusicStreamPlayer, "volume_db", -80, 1)
			await tweenMusic.finished
			$MusicStreamPlayer.playing = false
			$BossStreamPlayer.playing = true
		if Main.TalkingWithNPC == false:
			var tweenLumière = get_tree().create_tween()
			tweenLumière.tween_property($World/lumièreTree, "energy", 2, 2)
			await tweenLumière.finished
			spawn_boss()

func spawn_boss():
	if countSpawnBoss == 0:
		var SlimeScene = preload("res://scenes/character/slime/god_of_slimes.tscn")
		slime_boss = SlimeScene.instantiate()
		slime_boss.position = Vector2(-280, 138)
		add_child(slime_boss)
		countSpawnBoss = 1
