extends CharacterBody2D
var player = null # le node player
var health = 100 # la vie du slime
var speed = 30 # vitesse "inversé"
var player_chase = false # si oui, le slime va poursuivre le joueur`
var AttackZone = false # si oui, le player est dans la zone de combat du slime
var not_red_at = 0 # jsp ca marche pas mais c pour rendre le slime rouge
var canAttack = true # si oui, le slime peut attaquer

func updateHealth():
	var healthBar = $healthBar
	healthBar.value = health
	if health >= 100 :
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

func reginTimerPaused():
	if Global.gamePause == true:
		$reginTimer.paused = true
	else:
		$reginTimer.paused = false


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true
		print("detection du player, le slime le poursuit")
	
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player = null
		player_chase = false
		print("pas de detection du player, le slime ne le poursuit pas")

func playerChase():
	var direction = Vector2.ZERO	
	if player_chase :
		position += (player.position - position) / speed
		
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
	if AttackZone == true and canAttack == true and Global.gameStart == true:
		Global.playerHealth -= randi_range(7, 13)
		Global.enemyIsAttacking = true
		canAttack = false
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
			if health <=0 :
				queue_free()
			$reginTimer.start()
	
func enemy():
	pass
		

func apply_knockback(distance=20, time=0.1):
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
	


func _physics_process(delta):
	reginTimerPaused()
	if Global.gameStart == true:
		if Time.get_unix_time_from_system ( ) > not_red_at:
			deal_with_damage()
			updateHealth()
		playerChase()
		attack()
	#print("isAttacking" + str(isAttacking))
	#if canAttack == false:
		#print("canAttack" + str(canAttack))
	#if AttackZone == true:
		#print("AttackZone" + str(AttackZone))
	#if player_chase == true:
		#print("player_chase" + str(player_chase))







