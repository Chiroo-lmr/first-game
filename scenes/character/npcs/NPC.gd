extends CharacterBody2D
var dialogue = preload("res://dialogue/slimeThatPray.dialogue")
@onready var p = get_parent()
@onready var world = get_parent().get_parent().get_parent()
var Distance_P_NPC
var playerAnnoying
var CanTalk = true
var CountCanTalk = 0

func _process(delta):
	if Main.saidAllSlimesGones == false:
		$AnimatedSprite2D.play("idleStressed")
	elif Main.BossfightStarted:
		$AnimatedSprite2D.play("idleStressed")
	else:
		$AnimatedSprite2D.play("idleDestressed")
	
	if Main.saidAllSlimesGones and not Main.IsAtTheTree:
		if Main.TalkingWithNPC == false and not playerAnnoying and Main.gameStatus != "Pause":
			p.progress_ratio += delta * 0.1
		if p.progress_ratio == 1:
			Main.IsAtTheTree = true
		
	if Main.IsAtTheTree == true:
		$playerAbovePray/CollisionShape2D.disabled = false
	else:
		$playerAbovePray/CollisionShape2D.disabled = true
	if Main.gameStatus == "Start":
		if Main.TalkingWithNPC == true:
			if Main.playerAbovePraying == false:
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
	if Main.BossfightStarted == false:
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		Main.TalkingWithNPC = true
		CanTalk = false

func _on_player_above_pray_body_exited(body):
	Main.playerAbovePraying = false
