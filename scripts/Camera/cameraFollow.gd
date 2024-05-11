extends Camera2D
@onready var playerLivePosition 

func _process(delta):
	var world = get_parent()
	if Main.gameStatus != "Over":
		zoom = Vector2(Main.cameraZoom, Main.cameraZoom)
	if Main.player and Main.transitionScene == false:
		if Main.BossfightStarted:
			if Main.TalkingWithNPC:
				if world.get_node("PrayingTree"):
					var tweenCamera = get_tree().create_tween()
					tweenCamera.tween_property(world.get_node("WorldCamera"), "position", world.get_node("PrayingTree").position, 1)
					position = world.get_node("PrayingTree").position
			else:
				if world.get_node("god_of_slimes"):
					var tweenCamera = get_tree().create_tween()
					tweenCamera.tween_property(world.get_node("WorldCamera"), "zoom", Vector2(Main.cameraZoom, Main.cameraZoom), 1)
					tweenCamera.tween_property(world.get_node("WorldCamera"), "position", world.get_node("god_of_slimes").position, 1)
					position = world.get_node("god_of_slimes").position
		else:
			position = Main.playerLivePosition
		if Main.cameraSmoothing == true:
			position_smoothing_enabled = true
		else:
			position_smoothing_enabled = false

