extends CharacterBody2D
var dialogue = preload("res://dialogue/slimeThatPray.dialogue")

func _ready():
	$AnimatedSprite2D.play("idle")

func NPC():
	pass

func _process(delta):
	print(Global.TalkingWithNPC)

func _on_detection_player_body_entered(body):
	if body.has_method("player"):
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		Global.TalkingWithNPC = true
