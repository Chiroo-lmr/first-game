extends CharacterBody2D
var dialogue = preload("res://dialogue/slimeThatPray.dialogue")
@onready var p = get_parent()
@onready var world = get_parent().get_parent().get_parent()
var Distance_P_NPC
var playerAnnoying
var CanTalk = true
var CountCanTalk = 0

func _process(delta):
	print(Main.playerAbovePraying)
	if Main.saidAllSlimesGones == false:
		$AnimatedSprite2D.play("idleStressed")
	elif Main.BossfightStarted:
		$AnimatedSprite2D.play("idleStressed")
	else:
		$AnimatedSprite2D.play("idleDestressed")
	
	if Main.saidAllSlimesGones and not Main.IsAtTheTree:
		print("Starting boss fight")
		if Main.TalkingWithNPC == false and not playerAnnoying:
			p.progress_ratio += delta * 0.1
		if p.progress_ratio == 1:
			Main.IsAtTheTree = true
		
		# then we load the boss fight scene. 
		#var tween = get_tree().create_tween()
		#tween.tween_property(p.get_node("bgBlack"), "modulate:a", 1, 1)
		#await tween.finished
		#p.get_node("player").position = Vector2(-8, 116)
		#Main.currentScene = ("PrayingTree")
		#p.get_node("WorldCamera").limit_left = -1664
		#p.get_node("WorldCamera").limit_right = 0
		#if Main.currentScene == "Praying Tree":
			#p.get_node("cliffSideCollision/CollisionPolygon2D").disabled = false
		#Main.currentDirection = "left"
		#var tween2 = get_tree().create_tween()
		#tween2.tween_property(p.get_node("bgBlack"), "modulate:a", 0, 1)
		
	if Main.IsAtTheTree == true:
		$playerAbovePray/CollisionShape2D.disabled = false
	else:
		$playerAbovePray/CollisionShape2D.disabled = true
	if Main.gameStatus == "Start":
		if Main.TalkingWithNPC == true:
			var tween = get_tree().create_tween()
			tween.tween_property(world.get_node("WorldCamera"), "zoom", Vector2(5, 5), 3)
			CanTalk = false
			CountCanTalk = 0
			if Main.willRepeat == true:
				var tween1 = get_tree().create_tween()
				tween1.tween_property(world.get_node("WorldCamera"), "zoom", Vector2(2, 2), 3)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(world.get_node("WorldCamera"), "zoom", Vector2(Main.cameraZoom, Main.cameraZoom), 0.25)
			if CanTalk == false and CountCanTalk == 0:
				CountCanTalk = 1
				$CanTalk.start()
				await $CanTalk.timeout
				CanTalk = true

func NPC():
	pass

func _on_detection_player_body_entered(body):
	if body.has_method("player") and Main.BossfightStarted == false and CanTalk == true:
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		Main.TalkingWithNPC = true
		CanTalk = false

func _on_area_2d_body_entered(body):
	playerAnnoying = true

func _on_area_2d_body_exited(body):
	playerAnnoying = false

func _on_player_above_pray_body_entered(body):
	Main.playerAbovePraying = true

func _on_player_above_pray_body_exited(body):
	Main.playerAbovePraying = false
