extends Node2D
var world = preload("res://scenes/Maps/beginningScene/Beginning.tscn").instantiate()
var CountMusicBattle = 0
var countSpawnBoss = 0
var CountTweenModulate = 0
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
		$MusicStreamPlayer.playing = true
		$BossStreamPlayer.playing = false
		$Main_menu.visible = true
		remove_child($World)
		Main.is_menu_pressed = false

func HandleBossBattle():
	if Main.IsAtTheTree == true and Main.currentScene == "PrayingTree":
		$World/cliffSideTransitionPoint/CollisionPolygon2D.disabled = true
		$World/cliffSideCollision/CollisionPolygon2D.disabled = false
	if Main.willRepeat == true:
		var tweenLumière = get_tree().create_tween()
		tweenLumière.tween_property($World/lumièreTree, "energy", 2, 10)
	if Main.BossfightStarted:
		var tweenLumière = get_tree().create_tween()
		tweenLumière.tween_property($World/lumièreTree, "energy", 0, 1)
		await tweenLumière.finished
		if CountMusicBattle == 0:
			CountMusicBattle = 1
			var tweenMusic = get_tree().create_tween()
			tweenMusic.tween_property($MusicStreamPlayer, "volume_db", -80, 1)
			await tweenMusic.finished
			$MusicStreamPlayer.playing = false
			$BossStreamPlayer.playing = true
		if Main.TalkingWithNPC == false and $World != null:
			$World/bgBlack.modulate.r = 0.901
			$World/bgBlack.modulate.g = 1
			$World/bgBlack.modulate.b = 0.655
			print("tw commencé")
			if CountTweenModulate == 0:
				var tweenBlanc = get_tree().create_tween()
				tweenBlanc.tween_property($World/bgBlack, "modulate:a", 1, 1)
				await tweenBlanc.finished
				CountTweenModulate = 1
			spawn_boss()
			print(" 1 tw fini")
			if CountTweenModulate == 1:
				var tweenNormal = get_tree().create_tween()
				tweenNormal.tween_property($World/bgBlack, "modulate:a", 0, 1)
				await tweenNormal.finished
				$World/bgBlack.modulate.r = 0
				$World/bgBlack.modulate.g = 0
				$World/bgBlack.modulate.b = 0
				CountTweenModulate = 2
			print("tw fini")
			

func spawn_boss():
	if countSpawnBoss == 0:
		var SlimeScene = preload("res://scenes/character/slime/god_of_slimes.tscn")
		slime_boss = SlimeScene.instantiate()
		slime_boss.position = Vector2(-280, 138)
		add_child(slime_boss)
		countSpawnBoss = 1
