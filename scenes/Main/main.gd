extends Node2D
var CountMusicBattle = 0
var countSpawnBoss = 0
var CountTweenModulate = 0
var CountMusicPrayer = 0
var CountTweenCamTree = 0
var world = preload("res://scenes/Maps/beginningScene/Beginning.tscn")

func _process(delta):
	HandleBossBattle()
	HandleRestartAndMenu()
	HandleVisibleScenes()
	if not Main.BossfightStarted:
		$BossStreamPlayer.playing = false

func HandleVisibleScenes():
	if Main.playerHealth <= 0:
		$MusicStreamPlayer.playing = false
	if Main.gameStatus == "Launch":
		if $World != null:
			$World.visible = false
		$Main_menu.visible = true
	elif Main.gameStatus == "Start":
		if $World != null:
			$World.visible = true
		$Main_menu.visible = false

func HandleRestartAndMenu():
	if Main.is_restarting == true:
		get_node("World").queue_free()
		$Main_menu.visible = false
		var World = world.instantiate()
		add_child(World)
		World.name = "World"
		World.visible = true
		$MusicStreamPlayer.playing = true
		$BossStreamPlayer.playing = false
		$World/lightsBoss/lightVertical.energy = 0
		$World/lightsBoss/lightHorizontal.energy = 0
		CountMusicBattle = 0
		countSpawnBoss = 0
		CountTweenModulate = 0
		CountMusicPrayer = 0
		CountTweenCamTree = 0
		Main.is_restarting = false
	if Main.is_menu_pressed == true:
		$MusicStreamPlayer.playing = true
		$BossStreamPlayer.playing = false
		$Main_menu.visible = true
		$World.queue_free()
		Main.is_menu_pressed = false
		CountMusicBattle = 0
		countSpawnBoss = 0
		CountTweenModulate = 0
		CountMusicPrayer = 0
		CountTweenCamTree = 0

func HandleBossBattle():
	if Main.IsAtTheTree == true and Main.currentScene == "PrayingTree":
		$World/cliffSideTransitionPoint/CollisionPolygon2D.disabled = true
		$World/cliffSideCollision/CollisionPolygon2D.disabled = false
		if Main.playerAbovePraying and Main.TalkingWithNPC:
				if CountMusicPrayer == 0:
					CountMusicPrayer = 1
					var tweenMusic = get_tree().create_tween()
					tweenMusic.tween_property($MusicStreamPlayer, "volume_db", -80, 1)
					await tweenMusic.finished
					$MusicStreamPlayer.playing = false
					$prayerStreamPlayer.playing = true
					$MusicStreamPlayer.volume_db = -11.506
				
	if Main.willRepeat == true:
			var tweenLumière = get_tree().create_tween()
			tweenLumière.tween_property($World/lightsBoss/lumièreTree, "energy", 2, 10)

	if Main.BossfightStarted:
		#if CountTweenCamTree == 0:
			#CountTweenCamTree = 1
			#var tweenCamera = get_tree().create_tween()
			#tweenCamera.tween_property(get_node("World/WorldCamera"), "position", get_node("World/PrayingTree").position, 1)
			#$World/WorldCamera.position = get_node("World/WorldCamera").position
		var tweenLumière = get_tree().create_tween()
		tweenLumière.tween_property($World/lightsBoss/lumièreTree, "energy", 0, 1)
		await tweenLumière.finished
		if CountMusicBattle == 0:
			CountMusicBattle = 1
			var tweenMusic = get_tree().create_tween()
			tweenMusic.tween_property($prayerStreamPlayer, "volume_db", -80, 1)
			await tweenMusic.finished
			$prayerStreamPlayer.playing = false
			$BossStreamPlayer.playing = true
			$prayerStreamPlayer.volume_db = 0
		if Main.TalkingWithNPC == false and $World != null:
			$World/WorldCamera.position = $World/player.position
			if CountTweenModulate == 0:
				var tweenVertical = get_tree().create_tween()
				tweenVertical.tween_property($World/lightsBoss/lightVertical, "energy", 3, 1)
				await tweenVertical.finished
				CountTweenModulate = 1
			if CountTweenModulate == 1:
				var tweenHorizontal = get_tree().create_tween()
				tweenHorizontal.tween_property($World/lightsBoss/lightHorizontal, "energy", 3, 1)
				await tweenHorizontal.finished
				CountTweenModulate = 2
				var tweenVertical1 = get_tree().create_tween()
				tweenVertical1.tween_property($World/lightsBoss/lightVertical, "energy", 0, 1)
				var tweenHorizontal1 = get_tree().create_tween()
				tweenHorizontal1.tween_property($World/lightsBoss/lightHorizontal, "energy", 0, 1)
				spawn_boss()

func spawn_boss():
	if countSpawnBoss == 0:
		var position_slime = $World/PrayingTree.position
		$World/PrayingTree.queue_free()
		var god = preload("res://scenes/character/slime/god_of_slimes.tscn")
		var thegod = god.instantiate()
		$World.add_child(thegod)
		$World/god_of_slimes.position = position_slime 
		countSpawnBoss = 1
		Main.BossSpawned = true
