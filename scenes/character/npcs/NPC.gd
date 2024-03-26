extends CharacterBody2D
var dialogue = preload("res://dialogue/slimeThatPray.dialogue")

func _process(delta):
	if Global.saidAllSlimesGones == false:
		$AnimatedSprite2D.play("idleStressed")
	else:
		$AnimatedSprite2D.play("idleDestressed")
	
	if Global.QuestEnd and not Global.BossfightStarted:
		print("Starting boss fight")
		Global.BossfightStarted = true
		# then we load the boss fight scene. 
		# Other code about bossfight should be in res://scenes/Maps/PrayingTreeBossFight/PrayingTreeBossFight.gd
		
		get_tree().change_scene_to_file("res://scenes/Maps/PrayingTreeBossFight/PrayingTreeBossFight.tscn")
		

func NPC():
	pass

func _on_detection_player_body_entered(body):
	if body.has_method("player"):
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		Global.TalkingWithNPC = true
