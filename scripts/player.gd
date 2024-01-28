extends CharacterBody2D

const speed = 150
var currentDirection = "none"
var enemyAttackRange = false
var enemyAttackCooldown = true
var health = 100
var playerAlive = true
var attackIp = false

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	updateHealth()
	if health <= 0:
		playerAlive = false # respawn screen
		health = 0
		print("player has been killed")
		$AnimatedSprite2D.play("death")
		self.queue_free()


func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		currentDirection = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		play_anim(1)
		currentDirection = "left"
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):		
		currentDirection = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = +speed
	elif Input.is_action_pressed("ui_up"):
		currentDirection = "up"
		play_anim(1)		
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
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


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemyAttackRange = false

func enemy_attack():
	if enemyAttackRange and enemyAttackCooldown == true:
		health -= 20
		enemyAttackCooldown = false
		$attackCooldown.start()
		print(health)
		

func _on_attack_cooldown_timeout():
	enemyAttackCooldown = true
	
	

func attack():
	var dir = currentDirection
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
		












