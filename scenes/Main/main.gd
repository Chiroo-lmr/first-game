extends Node2D
var world = preload("res://scenes/Maps/beginningScene/Beginning.tscn").instantiate()
var CountMusicBattle = 0
var countSpawnBoss = 0
var CountTweenModulate = 0
var CountMusicPrayer = 0
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
		world.visible = true
		$MusicStreamPlayer.playing = true
		$BossStreamPlayer.playing = false
		$World/lightsBoss/lightVertical.energy = 0
		$World/lightsBoss/lightHorizontal.energy = 0
		CountMusicBattle = 0
		countSpawnBoss = 0
		CountTweenModulate = 0
		CountMusicPrayer = 0
		slime_boss
		Main.is_restarting = false
	if Main.is_menu_pressed == true:
		$MusicStreamPlayer.playing = true
		$BossStreamPlayer.playing = false
		$Main_menu.visible = true
		$World/lightsBoss/lightVertical.energy = 0
		$World/lightsBoss/lightHorizontal.energy = 0
		remove_child($World)
		Main.is_menu_pressed = false
		CountMusicBattle = 0
		countSpawnBoss = 0
		CountTweenModulate = 0
		CountMusicPrayer = 0
		slime_boss

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
			if CountTweenModulate == 0:
				var tweenVertical = get_tree().create_tween()
				tweenVertical.tween_property($World/lightsBoss/lightVertical, "energy", 1, 1)
				await tweenVertical.finished
				CountTweenModulate = 1
			if CountTweenModulate == 1:
				var tweenHorizontal = get_tree().create_tween()
				tweenHorizontal.tween_property($World/lightsBoss/lightHorizontal, "energy", 1, 1)
				await tweenHorizontal.finished
				CountTweenModulate = 2
				var tweenVertical1 = get_tree().create_tween()
				tweenVertical1.tween_property($World/lightsBoss/lightVertical, "energy", 0, 1)
				var tweenHorizontal1 = get_tree().create_tween()
				tweenHorizontal1.tween_property($World/lightsBoss/lightHorizontal, "energy", 0, 1)
				spawn_boss()
			

func spawn_boss():
	if countSpawnBoss == 0:
		$World/PrayingTree.queue_free()
		$World/god_of_slimes.visible = true
		countSpawnBoss = 1
