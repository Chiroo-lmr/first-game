extends CharacterBody2D

@export var speed = 150
var currentDirection = "none"
var enemyAttackRange = false
var enemyAttackCooldown = true
var playerAlive = true
var attackIp = false
var NPCInRange = false
var movement = 0
var not_red_at = 0

func apply_knockback(pos_slime, pos_player, distance=5, time=0.2):
	"""This function do the job for getting knockback after getting hit"""

	
	var xb = pos_player.x - pos_slime.x
	var yb = pos_player.y - pos_slime.y
	
	var X = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * xb
	var Y = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * yb
	
	var relative_new_coordinates = Vector2(X, Y)
	var new_coordinates = pos_player+relative_new_coordinates
	
	var collision = move_and_collide(relative_new_coordinates) # is null when nothing hit, else it is KinematicCollision2D

	if collision: # check if there is no collision
		# this code is called if the player it something
		var hit_position = position # get the stop position
		position = pos_player # we reset for the safe movement
		
		# then, we use a tween for make smooth movement
		var tween = create_tween()
		tween.tween_property(self,"position",hit_position,time)
		tween.tween_callback(
			func end_movement():
				position = hit_position
		)
		print("No collision")
	else:
		position = pos_player # the move_and_collide move the player, so we set coordinates to original coords for making smooth movement
		# then, we use a tween for creating smooth movement
		var tween = create_tween()
		tween.tween_property(self,"position",new_coordinates,time)
		tween.tween_callback(
			func end_movement():
				position = new_coordinates
		)
	


func _ready():
	Global.reginTimerPlayer = $reginTimer
	$AnimatedSprite2D.play("front_idle")
	
func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	ajustmentsHealth()
	if Time.get_unix_time_from_system ( ) < not_red_at:
		$AnimatedSprite2D.play("damage")
		
	if Global.playerHealth <= 0:
		playerAlive = false # respawn screen
		Global.playerHealth = 0
		print("Le joueur est mort")
		$AnimatedSprite2D.play("death")
		Global.gameOver = true
		Global.gameStart = false
		self.queue_free()
	if NPCInRange == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "main")
			return
		
func player_movement(delta):
	if Global.gameStart == true:
		if Time.get_unix_time_from_system() > not_red_at:
			var dirx = Input.get_axis("ui_left", "ui_right")
			var diry = Input.get_axis("ui_up", "ui_down")
			#print("horizontalement : " + str(dirx))
			#print("verticalement : " + str(diry))
			#print(currentDirection)
			#print(velocity)
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
		Global.playerHealth -= randi_range(15, 20)
		enemyAttackCooldown = false
		$attackCooldown.start()
		#print("le joueur a été touché, sa vie : " + str(Global.playerHealth))
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

func ajustmentsHealth():
	if Global.playerHealth > 100:
		Global.playerHealth = 100
		#print("Sa vie à té réajusté à 100")
	if Global.playerHealth <= 0 :
		Global.playerHealth = 0
		#print("Sa vie à té réajusté à 0")

func _on_regin_timer_timeout():
	if Global.playerHealth < 100:
		Global.playerHealth +=20
		#print("Le joueur s'est régénéré, sa vie : " + str(Global.playerHealth))
		
func _on_detection_np_cs_body_entered(body):
	if body.has_method("NPC"):
		NPCInRange = true
		


func _on_detection_np_cs_body_exited(body):
	if body.has_method("NPC"):
		NPCInRange = false
