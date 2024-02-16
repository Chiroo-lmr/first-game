extends CharacterBody2D

func _ready():
	$AnimatedSprite2D.play("idle")

func NPC():
	pass

func _on_detection_player_body_entered(body):
	print("yesss")
	if body.has_method("player"):
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "main")
			Global.TalkingWithNPC = true
			if Global.interacted_once == true:
				Global.TalkingWithNPC = false
