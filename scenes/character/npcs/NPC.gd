extends CharacterBody2D
var dialogue = preload("res://dialogue/slimeThatPray.dialogue")
@onready var p = get_parent()
@onready var world = get_parent().get_parent().get_parent()
var playerAnnoying
func NPC():
	pass

func _ready():
	preload("res://dialogue/slimeThatPray.dialogue")

func _process(delta):
	playAnim()
	walkToTheTree(delta)
	#print("CanTalk" + str(Main.CanTalk))
	#print("playerAnnoying" + str(playerAnnoying))
	#print("Main.TalkingWithNPC" + str(Main.TalkingWithNPC))

func walkToTheTree(delta):
	if Main.saidAllSlimesGones and not Main.IsAtTheTree:
		if Main.TalkingWithNPC == false and not playerAnnoying and Main.gameStatus != "Pause":
			p.progress_ratio += delta * 0.1
		if p.progress_ratio == 1:
			Main.IsAtTheTree = true

func playAnim():
	if Main.saidAllSlimesGones == false:
		$AnimatedSprite2D.play("idleStressed")
	elif Main.BossfightStarted:
		$AnimatedSprite2D.play("idleStressed")
	else:
		$AnimatedSprite2D.play("idleDestressed")

func _on_detection_player_body_entered(body):
	if body.has_method("player") and Main.BossfightStarted == false and Main.CanTalk == true:
		Main.TalkingWithNPC = true
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		Main.CanTalk = false

func _on_area_2d_body_entered(body):
	playerAnnoying = true

func _on_area_2d_body_exited(body):
	playerAnnoying = false

func _on_player_above_pray_body_entered(body):
	Main.playerAbovePraying = true
	if Main.BossfightStarted == false and Main.IsAtTheTree:
		Main.TalkingWithNPC = true
		DialogueManager.show_example_dialogue_balloon(dialogue, "main")
		print("slt")
		Main.CanTalk = false

func _on_player_above_pray_body_exited(body):
	Main.playerAbovePraying = false
