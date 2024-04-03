extends CanvasLayer

@onready var labelScore = %EnemyKilled
@onready var HealthBar = %HealthBar
@onready var boss_health_bar = %BossHealthBar
var CountTweebBar = 0

func _process(delta):
	if Main.is_restarting:
		CountTweebBar = 0
	updateHealth()
	npcLabelEnemies()
	updateBossHealth()
	if Input.is_action_pressed("information") and Main.gameStatus == "Start":
		game_tab()
	else:
		Main.gameTab = false
	if Main.gameStatus == "Over":
		HealthBar.visible = false
	

func updateBossHealth():
	if Main.BossfightStarted:
		print(boss_health_bar.value)
		boss_health_bar.value = Main.BossHealth * 100 / 4000
		visible = true
		if CountTweebBar == 0:
			CountTweebBar = 1
			var tweenBar = get_tree().create_tween()
			tweenBar.tween_property(boss_health_bar, "custom_minimum_size:x", 1920-64, 4)
			await tweenBar.finished
			Main.BossCanMove = true
		if Main.BossHealth <= 4000:
			boss_health_bar.visible = true
		if Main.BossHealth <= 0:
			boss_health_bar.visible = false
	else:
		boss_health_bar.visible = false

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
