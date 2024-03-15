extends CharacterBody2D
var player = null # le node player
var health = 100 # la vie du slime
var speed = 8 # multiplicateur en gros 
var player_chase = false # si oui, le slime va poursuivre le joueur`
var AttackZone = false # si oui, le player est dans la zone de combat du slime
var not_red_at = 0 # jsp ca marche pas mais c pour rendre le slime rouge
var canAttack = true # si oui, le slime peut attaquer
var canWalk = true
var animWalks = false
var isAlive = true

func _physics_process(delta):
	reginTimerPaused()
	handleParticles()
	move_and_slide()
	if isAlive == true:
		if Global.gameStart == true:
			if Time.get_unix_time_from_system ( ) > not_red_at:
				deal_with_damage()
				playerChase()
				updateHealth()
				attack()
				walk()
				ajustmentsHealth()
			else:
				$AnimatedSprite2D.play("damage")
		elif Global.gamePause == true:
			$AnimatedSprite2D.play("idle")
			$CPUParticles2D.emitting = false
			velocity = Vector2(0, 0)
		elif Global.gameOver == true:
			$AnimatedSprite2D.play("idle")
			$CPUParticles2D.emitting = false
			velocity = Vector2(0, 0)
	else:
		theSlimeHasNoHealth()

func handleParticles():
	if $AnimatedSprite2D.animation == "idle":
		$CPUParticles2D.emitting = true
		if velocity.x > 0:
			$CPUParticles2D.gravity.x = -150
		if velocity.x < 0:
			$CPUParticles2D.gravity.x = 150
		if velocity.y > 0:
			$CPUParticles2D.gravity.y = -150
		if velocity.y < 0:
			$CPUParticles2D.gravity.y = 150
	if velocity == Vector2(0, 0):
		$CPUParticles2D.emitting = false
		
		
func updateHealth():
	var healthBar = $healthBar
	healthBar.value = health
	if health >= 100 :
		healthBar.visible = false
	elif health > 0:
		healthBar.visible = true

func ajustmentsHealth():
	if health > 100:
		health = 100
	if health <= 0 :
		health = 0
		isAlive = false
		theSlimeHasNoHealth()


func _on_regin_timer_timeout():
	if health < 100:
		health +=20
		if health > 100:
			health = 100
	if health <= 0 :
		health = 0

func reginTimerPaused():
	if Global.gamePause == true:
		$reginTimer.paused = true
	else:
		$reginTimer.paused = false


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true
	
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player = null
		player_chase = false

func playerChase():
	if player_chase:
		velocity = (player.position - position) * speed
		$CPUParticles2D.emitting = false
		$AnimatedSprite2D.play("walk")
		if (player.position.x - position.x) < 0 :
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		move_and_collide(Vector2(0,0))
	else:
		$AnimatedSprite2D.play("idle")
		$CPUParticles2D.emitting = true
		

# detecte si le joueur est dans la collision de combat du slime
func _on_enemy_hitbox_combat_body_entered(body):
	if body.has_method("player"):
		AttackZone = true
		
func _on_enemy_hitbox_combat_body_exited(body):
	if body.has_method("player"):
		AttackZone = false

func attack():
	if AttackZone == true and canAttack == true and Global.gameStart == true and isAlive == true:
		Global.playerHealth -= randi_range(7, 13)
		Global.enemyIsAttacking = true
		canAttack = false
		Global.not_red_at = Time.get_unix_time_from_system() + 0.5
		$canAttackCooldown.start()
	else:Global.enemyIsAttacking = false
		
func _on_can_attack_cooldown_timeout():
	canAttack = true
	Global.enemyIsAttacking = true

func deal_with_damage():
	if Global.playerCurrentAttack == true and AttackZone == true:
			health -= randi_range(15, 20)
			$canAttackCooldown.start()
			apply_knockback() 
			not_red_at = Time.get_unix_time_from_system ( ) + 0.3
			$reginTimer.start()
	
func enemy():
	pass
		

func apply_knockback(distance=10, time=0.1):
	var pos = self.position
	var player_pos = get_parent().get_node("player").position
	
	print("PLAYER POS --->" + str(player_pos))
	
	var xb = pos.x - player_pos.x
	var yb = pos.y - player_pos.y
	
	var X = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * xb
	var Y = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * yb
	
	var relative_new_coordinates = Vector2(X, Y)
	var new_coordinates = pos+relative_new_coordinates
	
	var collision = move_and_collide(relative_new_coordinates) # is null when nothing hit, else it is KinematicCollision2D
	if collision: # check if there is no collision
		new_coordinates = self.position # get the stop position		
	self.position = pos # the move_and_collide move the player, so we set coordinates to original coords for making smooth movement
	var tween = create_tween()
	tween.tween_property(self,"position",new_coordinates,time)
	tween.tween_callback(
		func end_movement():
			self.position = new_coordinates
	)

func walk():
	if canWalk == true and not player_chase:
		var direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
		velocity = direction * 250
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
		$waitToWalk.start()
		canWalk = false

func _on_wait_to_walk_timeout():
	canWalk = true

func theSlimeHasNoHealth():
	$hitboxElements.disabled = true
	$healthBar.visible = false
	velocity = Vector2(0, 0)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()

