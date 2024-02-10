extends CharacterBody2D

const speed = 150
var currentDirection = "none"
var enemyAttackRange = false
var enemyAttackCooldown = true
var health = Global.playerHealth
var playerAlive = true
var attackIp = false
var NPCInRange = false
var movement = 0
var not_red_at = 0

func apply_knockback(pos_slime, pos_player, distance=20, time=0.1):
	"""This function do the job for getting knockback after getting hit"""

	
	var xb = pos_player.x - pos_slime.x
	var yb = pos_player.y - pos_slime.y
	
	var X = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * xb
	var Y = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * yb
	
	var new_coordinates = pos_player+Vector2(X, Y)
	
	var tween = create_tween()
	var target_pos = new_coordinates
	tween.tween_property(self,"position",target_pos,time)
	tween.tween_callback(
		func end_movement():
			self.position = target_pos
	)

func _ready():
	$AnimatedSprite2D.play("front_idle")
	
func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	updateHealth()
	if Time.get_unix_time_from_system ( ) < not_red_at:
		$AnimatedSprite2D.play("damage")
		
	if health <= 0:
		playerAlive = false # respawn screen
		health = 0
		print("player has been killed")
		$AnimatedSprite2D.play("death")
		Global.gameOver = true
		Global.gameStart = false
		self.queue_free()
	if NPCInRange == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "main")
			return
		
func player_movement(delta):
	if Global.gameStart == true and Global.gamePause == false:
		if Time.get_unix_time_from_system() > not_red_at:
			if Input.is_action_pressed("ui_right"):
				currentDirection = "right"
				movement = 1
				play_anim(1)
				velocity.x = speed
				velocity.y = 0
			elif Input.is_action_pressed("ui_left"):
				currentDirection = "left"
				play_anim(1)
				movement = 1
				velocity.x = -speed
				velocity.y = 0
			elif Input.is_action_pressed("ui_down"):		
				currentDirection = "down"
				play_anim(1)
				movement = 1
				velocity.x = 0
				velocity.y = +speed
			elif Input.is_action_pressed("ui_up"):
				currentDirection = "up"
				play_anim(1)		
				movement = 1
				velocity.x = 0
				velocity.y = -speed
			else:
				play_anim(0)
				movement = 0
				velocity.x = 0
				velocity.y = 0
			
			move_and_slide()
	
func play_anim(movement):
	var dir = currentDirection
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attackIp == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attackIp == false:
				anim.play("side_idle")
	if dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attackIp == false:
				anim.play("front_idle")
	if dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attackIp == false:
				anim.play("back_idle")
	
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemyAttackRange = true
		
		var pos_slime = body.position
		var pos_player = self.position
		apply_knockback(pos_slime, pos_player)
		

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemyAttackRange = false

func enemy_attack():
	if enemyAttackRange and enemyAttackCooldown == true and Global.gamePause == false:
		health -= 20
		enemyAttackCooldown = false
		$attackCooldown.start()
		print(health)
		print("debug --> player get hit")
		not_red_at = Time.get_unix_time_from_system() + 0.5
		
func _on_attack_cooldown_timeout():
	enemyAttackCooldown = true

func attack():
	if Global.gamePause == false and Global.gameStart == true and Global.gameLaunch == false:
		var dir = currentDirection
		if movement == 0:
			if Input.is_action_just_pressed("attack"):
				Global.playerCurrentAttack = true
				attackIp = true
				if dir == "right":
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play("side_attack")
					$deal_attack_timer.start()
				if dir == "left":
					$AnimatedSprite2D.flip_h = true
					$AnimatedSprite2D.play("side_attack")
					$deal_attack_timer.start()
				if dir == "down":
					$AnimatedSprite2D.play("front_attack")
					$deal_attack_timer.start()
				if dir == "up":
					$AnimatedSprite2D.play("back_attack")
					$deal_attack_timer.start()
	
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.playerCurrentAttack = false
	attackIp = false
	
func updateHealth():
	var healthBar = $healthBar
	healthBar.value = health
	if health >= 100:
		healthBar.visible = false
	else:
		healthBar.visible = true

func _on_regin_timer_timeout():
	if health < 100:
		health +=20
		if health > 100:
			health = 100
	if health <= 0 :
		health = 0
		
func _on_detection_np_cs_body_entered(body):
	if body.has_method("NPC"):
		NPCInRange = true
		


func _on_detection_np_cs_body_exited(body):
	if body.has_method("NPC"):
		NPCInRange = false
