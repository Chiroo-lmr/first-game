extends CanvasLayer

@onready var labelScore = %EnemyKilled
@onready var HealthBar = %HealthBar
	
func _process(delta):
	updateHealth()
	npcLabelEnemies()
	if Input.is_action_pressed("information") and Main.gameStatus == "Start":
		game_tab()
	else:
		Main.gameTab = false
	if Main.gameStatus == "Over":
		HealthBar.visible = false
	

func npcLabelEnemies():
	if Main.label == 1:
		visible = true
		$MarginContainer.visible = true
		labelScore.visible = true
		labelScore.text = "Killed enemies : " + str(Main.enemiesKilled)
	else:
		labelScore.visible = false

func game_tab():
	Main.gameStatus = "Start"
	Main.gameTab = true

func updateHealth():
	HealthBar.value = Main.playerHealth
	if Main.playerHealth < 100 and Main.playerHealth > 0 :
		visible = true
		$MarginContainer.visible = true
		HealthBar.visible = true
	elif Main.playerHealth == 0 or Main.playerHealth == 100 and Main.gameTab == false:
		visible = false
		HealthBar.visible = false
	elif Main.gameTab == true:
		visible = true
		$MarginContainer.visible = true
		HealthBar.visible = true
