extends Camera2D
@onready var playerLivePosition 

func _process(delta):
	if Global.player:
		position = Global.playerLivePosition
		position_smoothing_enabled = true

