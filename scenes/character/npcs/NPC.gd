extends CharacterBody2D
var dialogue = preload("res://dialogue/slimeThatPray.dialogue")

func _process(delta):
	if Main.saidAllSlimesGones == false:
		$AnimatedSprite2D.play("idleStressed")
	else:
		$AnimatedSprite2D.play("idleDestressed")
	if Main.TalkingWithNPC == true:
		var tween = get_tree().create_tween()
		tween.tween_property(get_parent().get_node("CS2Camera"), "zoom", Vector2(5, 5), 1.5)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(get_parent().get_node("CS2Camera"), "zoom", Vector2(Main.cameraZoom, Main.cameraZoom), 0.25)

func NPC():
	pass

func _on_detection_player_body_entered(body):
	if body.has_method("player"):
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		Main.TalkingWithNPC = true
