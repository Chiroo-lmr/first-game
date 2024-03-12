extends CanvasLayer

@onready var labelScore = %EnemyKilled
@onready var HealthBar = %HealthBar
	
func _process(delta):
	updateHealth()
	if Input.is_action_pressed("information") and Global.gameStart == true:
		game_tab()
	else:
		Global.gameTab = false
	if Global.label == 1:
		labelScore.visible = true
		labelScore.text = "Killed enemies : " + str(Global.enemiesKilled)
	else:
		labelScore.visible = false
	
func game_tab():
	Global.gameStart = true
	Global.gameTab = true

func updateHealth():
	HealthBar.value = Global.playerHealth
	if Global.playerHealth < 100 and Global.playerHealth > 0 :
		HealthBar.visible = true
	elif Global.playerHealth == 0 or Global.playerHealth == 100 and Global.gameTab == false:
		HealthBar.visible = false
	elif Global.gameTab == true:
		HealthBar.visible = true
