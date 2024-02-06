extends Camera2D
@onready var playerLivePosition 

func _ready():
	pass

func _process(delta):
	playerLivePosition = get_parent().get_node("player")
	if playerLivePosition:
		position = playerLivePosition.position
		position_smoothing_enabled = true
