extends CharacterBody2D

func _ready():
	$AnimatedSprite2D.play("idle")

func NPC():
	pass

func _process(delta):
	print(Global.TalkingWithNPC)

func _on_detection_player_body_entered(body):
	if body.has_method("player"):
		print("yesss")
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "main")
		Global.TalkingWithNPC = true
