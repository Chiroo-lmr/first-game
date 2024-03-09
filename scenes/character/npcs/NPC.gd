extends CharacterBody2D
var dialogue = preload("res://dialogue/slimeThatPray.dialogue")

func _process(delta):
	if Global.saidAllSlimesGones == false:
		$AnimatedSprite2D.play("idleStressed")
	else:
		$AnimatedSprite2D.play("idleDestressed")

func NPC():
	pass

func _on_detection_player_body_entered(body):
	if body.has_method("player"):
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		Global.TalkingWithNPC = true
