extends Camera2D
@onready var playerLivePosition 

func _process(delta):
	if Main.gameStatus != "Over":
		zoom = Vector2(Main.cameraZoom, Main.cameraZoom)
	if Main.player and Main.transitionScene == false:
		position = Main.playerLivePosition
		if Main.cameraSmoothing == true:
			position_smoothing_enabled = true
		else:
			position_smoothing_enabled = false

