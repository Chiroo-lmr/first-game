extends CharacterBody2D

@export var speed = 600
var enemyAttackRange = false # utilisé quand l'ennemy et dans la zone ou le player peut attaquer
var enemyAttackCooldown = true
var movement = 0 # utilisé pour savoir si le player bouge
var canAttack = true # utilisé pour ne pouvoir attaquer que une fois toute les secondes
var isAttacking = false
var canBeKnockback = false
var countForSound = 0 # j'ai trouvé que cette solution un peu bullshit jsp comment faire autrement
var enemy
var canBeRed = true

func _ready():
	$AnimatedSprite2D.play("front_idle")
	Global.player = self
	$canAttackCooldown.start()

func _physics_process(delta):
	Global.playerLivePosition = position
	if Global.gameStatus == "Start":
		player_movement(delta)
		attackPressedAnim()
		play_anim(movement)
		ajustmentsHealth()
		checkAttackNPC()
		checkIfAttacked()
	if Global.gameStatus == "Pause":
		gamePause()

func gamePause():
	if Global.currentDirection == "up":
		$AnimatedSprite2D.play("back_idle")
	elif Global.currentDirection == "down":
		$AnimatedSprite2D.play("front_idle")
	elif Global.currentDirection == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_idle")
	elif Global.currentDirection == "right":
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("side_idle")
	$walks.stop()
	if Global.gameStatus == "Pause":
		$regin.paused = true
	else:
		$regin.paused = false

func player_movement(delta):
	if Global.TalkingWithNPC == false:
		var dirx = Input.get_axis("ui_left", "ui_right")
		var diry = Input.get_axis("ui_up", "ui_down")
		if !dirx == 0 and !diry == 0:
			movement = 1
			play_anim(1)
			velocity = Vector2(dirx * speed / 1.4, diry * speed / 1.4)
		else:
			if diry == -1:
				Global.currentDirection = "up"
				movement = 1
				play_anim(1)
				velocity.y = diry * speed
				velocity.x = 0
			if diry == 1:
				Global.currentDirection = "down"
				movement = 1
				play_anim(1)
				velocity.y = diry * speed
				velocity.x = 0
			if dirx == -1:
				Global.currentDirection = "left"
				movement = 1
				play_anim(1)
				velocity.x = dirx * speed
				velocity.y = 0
			if dirx == 1:
				Global.currentDirection = "right"
				movement = 1
				play_anim(1)
				velocity.x = dirx * speed
				velocity.y = 0
		if dirx == 0 and diry == 0:
			movement = 0
			play_anim(0)
			velocity.x = 0
			velocity.y = 0
		move_and_slide()
	
func play_anim(mov):
	if Global.gameStatus == "Start":
		var dir = Global.currentDirection
		var anim = $AnimatedSprite2D
		if dir == "right" and Global.TalkingWithNPC == false:
			anim.flip_h = false
			if movement == 1 and isAttacking == true:
				anim.play("side_attack")
			elif movement == 1 and isAttacking == false:
				anim.play("side_walk")
			elif movement == 0 and isAttacking == false:
				anim.play("side_idle")
		if dir == "left" and Global.TalkingWithNPC == false:
			anim.flip_h = true
			if movement == 1 and isAttacking == true:
				anim.play("side_attack")
			elif movement == 1 and isAttacking == false:
				anim.play("side_walk")
			elif movement == 0 and isAttacking == false:
				anim.play("side_idle")
		if dir == "down" and Global.TalkingWithNPC == false:
			if movement == 1 and isAttacking == true:
				anim.play("front_attack")
			if movement == 1 and isAttacking == false:
				anim.play("front_walk")
			elif movement == 0 and isAttacking == false:
				anim.play("front_idle")
		if dir == "up" and Global.TalkingWithNPC == false:
			if movement == 1 and isAttacking == true:
				anim.play("back_attack")
			if movement == 1 and isAttacking == false:
				anim.play("back_walk")
			elif movement == 0 and isAttacking == false:
				anim.play("back_idle")
		if Global.TalkingWithNPC == true:
			if dir == "right": anim.play("side_idle")
			elif dir == "left": 
				anim.flip_h = true
				anim.play("side_idle")
			elif dir == "up": anim.play("back_idle")
			elif dir == "down": anim.play("front_idle")
		if dir == "none":
			if isAttacking == false:
				anim.play("front_idle")
		if movement == 1 and countForSound == 0:
			$walks.play()
			countForSound += 1
		if movement == 0 and countForSound == 1:
			$walks.stop()
			countForSound-= 1
		if Global.TalkingWithNPC == true:
			$walks.stop()

func apply_knockback(distance=20, time=0.1):
	"""This function do the job for getting knockback after getting hit"""
	var pos_player = position
	var pos_slime = enemy.position
	
	var xb = pos_player.x - pos_slime.x
	var yb = pos_player.y - pos_slime.y
	
	var X = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * xb
	var Y = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * yb
	
	var relative_new_coordinates = Vector2(X, Y)
	var new_coordinates = pos_player+relative_new_coordinates
	
	var collision = move_and_collide(relative_new_coordinates) # is null when nothing hit, else it is KinematicCollision2D

	if collision: # check if there is collision
		new_coordinates = position # get the stop position
			
	self.position = pos_player # the move_and_collide move the player, so we set coordinates to original coords for making smooth movement
	var tween = create_tween()
	tween.tween_property(self,"position",new_coordinates,time)
	tween.tween_callback(
		func end_movement():
			self.position = new_coordinates
	)

func checkIfAttacked():
	if Global.enemyIsAttacking == true and canBeKnockback and Global.gameStatus == "Start" and canBeRed == true:
		apply_knockback()
		$AnimatedSprite2D.modulate = Color(1, 0, 0)
		var tweenModulate = get_tree().create_tween()
		tweenModulate.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.5)
		play_anim(movement)

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemyAttackRange = true
		canBeKnockback = true
		enemy = body

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemyAttackRange = false
		canBeKnockback = false
	
func attackPressedAnim():
	if Input.is_action_pressed("attack") and canAttack == true and Global.gameStatus == "Start" and Global.TalkingWithNPC == false:
		var dir = Global.currentDirection
		var anim = $AnimatedSprite2D
		isAttacking = true
		canBeRed = false
		Global.playerCurrentAttack = true
		$timeBeforeSoundAttack.start()
		$attack.play()
		velocity = Vector2(0, 0)
		if dir == "right" and canAttack == true:
			anim.flip_h = false
			anim.play("side_attack", 1, true)
			$canAttackCooldown.start()
			$isAttacking.start()
		if dir == "left":
			anim.flip_h = true
			anim.play("side_attack")
			$canAttackCooldown.start()
			$isAttacking.start()
		if dir == "down":
			anim.play("front_attack")
			$canAttackCooldown.start()
			$isAttacking.start()
		if dir == "up":
			anim.play("back_attack")
			$canAttackCooldown.start()
			$isAttacking.start()
		if dir == "none":
			anim.play("front_attack")
			$canAttackCooldown.start()
			$isAttacking.start()
		canAttack = false
		Global.playerCanAttack = false
	else:
		Global.playerCurrentAttack = false

func _on_is_attacking_timeout():
	$isAttacking.stop()
	isAttacking = false
	canBeRed = true
	Global.playerCurrentAttack = false

func ajustmentsHealth():
	if Global.playerHealth > 100:
		Global.playerHealth = 100
	if Global.playerHealth <= 0 :
		Global.playerHealth = 0
		thePlayerHasNoHealth()

func thePlayerHasNoHealth():
	Global.gameStatus = "Over"
	$walks.stop()
	gamePause() # economiser du code je suis un rat oui
	var camera = get_parent().get_node("WorldCamera")
	var tweenZoom = get_tree().create_tween()
	tweenZoom.tween_property(camera, "zoom", Vector2(4, 4), 2).as_relative().set_trans(Tween.TRANS_SINE)
	await tweenZoom.finished
	z_index = 2
	$AnimatedSprite2D.play("death")
	$death.play()
	var BGBlack = get_parent().get_node("bgBlack")
	var tweenBGBlack = get_tree().create_tween()
	tweenBGBlack.tween_property(BGBlack, "modulate:a", 1, 2)
	await tweenBGBlack.finished
	Global.ButtonsGameOver = true

func _on_can_attack_cooldown_timeout():
	Global.playerCanAttack = true
	canAttack = true

func _on_timer_timeout():
	if Global.TalkingWithNPC == false:
		if Global.playerHealth < 100:
			Global.playerHealth +=20
			
func checkAttackNPC():
	if Global.TalkingWithNPC:
		if Global.playerCanAttack == false:
			$canAttackCooldown.paused = true
			canAttack = Global.playerCanAttack
	else:
		$canAttackCooldown.paused = false








