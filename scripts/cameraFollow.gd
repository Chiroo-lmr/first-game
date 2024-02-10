extends Camera2D
@onready var playerLivePosition 

func _ready():
	zoom = Vector2(1.25, 1.25)

func _process(delta):
	playerLivePosition = get_parent().get_node("player")
	global_transform.origin = Global.cameraPosition
	if playerLivePosition:
		position = playerLivePosition.position
		position_smoothing_enabled = true
