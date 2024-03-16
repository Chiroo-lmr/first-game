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
	move_and_slide()
	if isAlive == true:
		if Global.gameStatus == "Start":
				deal_with_damage()
				playerChase()
				updateHealth()
				attack()
				walk()
				ajustmentsHealth()
		elif Global.gameStatus == "Pause":
			$AnimatedSprite2D.play("idle")
			velocity = Vector2(0, 0)
		elif Global.gameStatus == "Over":
			$AnimatedSprite2D.play("idle")
			velocity = Vector2(0, 0)
	else:
		theSlimeHasNoHealth()

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
	if Global.gameStatus == "Pause":
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
		
		$AnimatedSprite2D.play("walk")
		if (player.position.x - position.x) < 0 :
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		move_and_collide(Vector2(0,0))
	else:
		$AnimatedSprite2D.play("idle")
		

# detecte si le joueur est dans la collision de combat du slime
func _on_enemy_hitbox_combat_body_entered(body):
	if body.has_method("player"):
		AttackZone = true
		
func _on_enemy_hitbox_combat_body_exited(body):
	if body.has_method("player"):
		AttackZone = false

func attack():
	if AttackZone == true and canAttack == true and Global.gameStatus == "Start" and isAlive == true:
		Global.playerHealth -= randi_range(7, 13)
		Global.enemyIsAttacking = true
		canAttack = false
		$canAttackCooldown.start()
		$enemyIsAttackingTime.start()
		await $enemyIsAttackingTime.timeout
		Global.enemyIsAttacking = false
		
func _on_can_attack_cooldown_timeout():
	Global.enemyIsAttacking = false
	canAttack = true

func deal_with_damage():
	if Global.playerCurrentAttack == true and AttackZone == true:
			health -= randi_range(15, 20)
			$canAttackCooldown.start()
			apply_knockback() 
			$AnimatedSprite2D.modulate = Color(1, 0, 0)
			var tweenModulate = get_tree().create_tween()
			tweenModulate.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.5)
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

