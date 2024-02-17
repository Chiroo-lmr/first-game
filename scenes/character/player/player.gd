extends CharacterBody2D

@export var speed = 600
var currentDirection = "none" # utilisé pour les animations 
var enemyAttackRange = false # utilisé quand l'ennemy et dans la zone ou le player peut attaquer
var enemyAttackCooldown = true
var playerAlive = true # utilisé pour l'ui de mort
var attackPressed = false # utilisé quand le bouton pour attaquer est pressé
var movement = 0 # utilisé pour savoir si le player bouge
var not_red_at = 0 # utilisé pour rendre le player rouge quand attaqué 
var canAttack = false # utilisé pour ne pouvoir attaquer que une fois toute les secondes

func _ready():
	Global.reginTimerPlayer = $reginTimer
	$AnimatedSprite2D.play("front_idle")
	Global.player = self

func _physics_process(delta):
	Global.playerLivePosition = position
	if Global.gameStart == true:
		player_movement(delta)
		the_enemy_attack()
		attackPressedAnim()
		playerRed()
		thePlayerHasNoHealth()
		play_anim(movement)
		ajustmentsHealth()

func player_movement(delta):
	if Global.TalkingWithNPC == false:
		if Time.get_unix_time_from_system() > not_red_at:
			var dirx = Input.get_axis("ui_left", "ui_right")
			var diry = Input.get_axis("ui_up", "ui_down")
			#print("horizontalement : " + str(dirx))
			#print("verticalement : " + str(diry))
			#print(currentDirection)
			#print(velocity)
			#print(movement)
			#print(attackPressed)
			if !dirx == 0 and !diry == 0:
				movement = 1
				play_anim(1)
				velocity = Vector2(dirx * speed / 1.4, diry * speed / 1.4)
			else:
				if diry == -1:
					currentDirection = "up"
					movement = 1
					play_anim(1)
					velocity.y = diry * speed
					velocity.x = 0
				if diry == 1:
					currentDirection = "down"
					movement = 1
					play_anim(1)
					velocity.y = diry * speed
					velocity.x = 0
				if dirx == -1:
					currentDirection = "left"
					movement = 1
					play_anim(1)
					velocity.x = dirx * speed
					velocity.y = 0
				if dirx == 1:
					currentDirection = "right"
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
	
func play_anim(movement):
	var dir = currentDirection
	var anim = $AnimatedSprite2D
	
	if dir == "right" and Global.TalkingWithNPC == false:
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attackPressed == false:
				anim.play("side_idle")
	if dir == "left" and Global.TalkingWithNPC == false:
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attackPressed == false:
				anim.play("side_idle")
	if dir == "down" and Global.TalkingWithNPC == false:
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attackPressed == false:
				anim.play("front_idle")
	if dir == "up" and Global.TalkingWithNPC == false:
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attackPressed == false:
				anim.play("back_idle")
	if Global.TalkingWithNPC == true:
		if dir == "right": anim.play("side_idle")
		elif dir == "left": 
			anim.flip_h = true
			anim.play("side_idle")
		elif dir == "up": anim.play("back_idle")
		elif dir == "down": anim.play("front_idle")

func apply_knockback(pos_slime, pos_player, distance=5, time=0.1):
	"""This function do the job for getting knockback after getting hit"""
	var xb = pos_player.x - pos_slime.x
	var yb = pos_player.y - pos_slime.y
	var X = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * xb
	var Y = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * yb
	var relative_new_coordinates = Vector2(X, Y)
	var new_coordinates = pos_player+relative_new_coordinates
	var collision = move_and_collide(relative_new_coordinates) # is null when nothing hit, else it is KinematicCollision2D

	if !collision: # check if there is no collision
		self.position = pos_player # the move_and_collide move the player, so we set coordinates to original coords for making smooth movement
		# then, we use a tween for creating smooth movement
		var tween = create_tween()
		tween.tween_property(self,"position",new_coordinates,time)
		tween.tween_callback(
			func end_movement():
				self.position = new_coordinates
		)
	else:
		# this code is called if the player it something
		var hit_position = self.position # get the stop position
		self.position = pos_player # we reset for the safe movement
		
		# then, we use a tween for make smooth movement
		var tween = create_tween()
		tween.tween_property(self,"position",hit_position,time)
		tween.tween_callback(
			func end_movement():
				self.position = hit_position
		)

func playerRed():
	if Time.get_unix_time_from_system ( ) < not_red_at:
		$AnimatedSprite2D.play("damage")

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

func _on_regin_timer_timeout():
	if Global.playerHealth < 100:
		Global.playerHealth +=20
		#print("Le joueur s'est régénéré, sa vie : " + str(Global.playerHealth))

func the_enemy_attack():
	if enemyAttackRange == true and enemyAttackCooldown == true and Global.gameStart == true:
		Global.playerHealth -= randi_range(15, 20)
		enemyAttackCooldown = false
		$canAttack.start()
		#print("le joueur a été touché, sa vie : " + str(Global.playerHealth))
		not_red_at = Time.get_unix_time_from_system() + 0.5

func attackPressedAnim():
	if Global.gameStart == true and Global.TalkingWithNPC == false:
		var dir = currentDirection
		if movement == 0:
			if Input.is_action_just_pressed("attack") and canAttack == true:
				Global.playerCurrentAttack = true
				attackPressed = true
				if dir == "right":
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play("side_attack")
					$canAttack.start()   
				if dir == "left":
					$AnimatedSprite2D.flip_h = true
					$AnimatedSprite2D.play("side_attack")
					$canAttack.start()
				if dir == "down":
					$AnimatedSprite2D.play("front_attack")
					$canAttack.start()
				if dir == "up":
					$AnimatedSprite2D.play("back_attack")
					$canAttack.start()

func ajustmentsHealth():
	if Global.playerHealth > 100:
		Global.playerHealth = 100
		#print("Sa vie à té réajusté à 100")
	if Global.playerHealth <= 0 :
		Global.playerHealth = 0
		#print("Sa vie à té réajusté à 0")

func thePlayerHasNoHealth():
	if Global.playerHealth <= 0:
		playerAlive = false # respawn screen
		Global.playerHealth = 0
		#print("Le joueur est mort")
		$AnimatedSprite2D.play("death")
		Global.gameOver = true
		Global.gameStart = false
		self.queue_free()

func _on_can_attack_cooldown_timeout():
	canAttack = true
	print(canAttack)
	if Global.gameStart == true:
		$canAttackCooldown.start()
