extends CharacterBody2D
var dialogue = preload("res://dialogue/slimeThatPray.dialogue")

func _process(delta):
	if Main.saidAllSlimesGones == false:
		$AnimatedSprite2D.play("idleStressed")
	elif Main.BossfightStarted:
		$AnimatedSprite2D.play("idleStressed")
	else:
		$AnimatedSprite2D.play("idleDestressed")
	
	if Main.saidAllSlimesGones and not Main.BossfightStarted:
		print("Starting boss fight")
		Main.BossfightStarted = true
		# then we load the boss fight scene. 
		var p = get_parent()
		var tween = get_tree().create_tween()
		tween.tween_property(p.get_node("bgBlack"), "modulate:a", 1, 1)
		await tween.finished
		p.get_node("player").position = Vector2(-8, 116)
		Main.currentScene = ("PrayingTree")
		p.get_node("WorldCamera").limit_left = -1664
		p.get_node("WorldCamera").limit_right = 0
		p.get_node("cliffSideCollision/CollisionPolygon2D").disabled = false
		Main.currentDirection = "left"
		var tween2 = get_tree().create_tween()
		tween2.tween_property(p.get_node("bgBlack"), "modulate:a", 0, 1)
		
		
	if Main.TalkingWithNPC == true:
		var tween = get_tree().create_tween()
		tween.tween_property(get_parent().get_node("WorldCamera"), "zoom", Vector2(5, 5), 1.5)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(get_parent().get_node("WorldCamera"), "zoom", Vector2(Main.cameraZoom, Main.cameraZoom), 0.25)

func NPC():
	pass

func _on_detection_player_body_entered(body):
	if body.has_method("player") and Main.BossfightStarted == false:
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		Main.TalkingWithNPC = true
