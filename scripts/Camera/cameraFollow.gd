extends Camera2D
@onready var playerLivePosition 

func _process(delta):
	if Global.player:
		position = Global.playerLivePosition
		if Global.cameraSmoothing == true:
			position_smoothing_enabled = true
		else:
			position_smoothing_enabled = false

