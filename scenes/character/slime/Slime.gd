extends CharacterBody2D
@export_enum("God", "Slime") var Slime_type
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

func _ready():
	if Slime_type == 0:
		health = 4000
	if Slime_type == 1:
		health = 100

func _physics_process(delta):
	reginTimerPaused()
	move_and_slide()
	if isAlive == true:
		if Main.gameStatus == "Start":
				deal_with_damage()
				playerChase()
				updateHealth()
				attack()
				if Slime_type == 0:
					if Main.BossCanMove:
						walk()
				if Slime_type == 1:
					walk()
				ajustmentsHealth()
		elif Main.gameStatus == "Pause":
			$AnimatedSprite2D.play("idle")
			$CPUParticles2D.emitting = false
			velocity = Vector2(0, 0)
		elif Main.gameStatus == "Over":
			$AnimatedSprite2D.play("idle")
			$CPUParticles2D.emitting = false
			velocity = Vector2(0, 0)
	else:
		theSlimeHasNoHealth()

func updateHealth():
	if Slime_type == 1:
		var healthBar = $healthBar
		healthBar.value = health
		if health >= 100 :
			healthBar.visible = false
		elif health > 0:
			healthBar.visible = true
	if Slime_type == 0:
		Main.BossHealth = health

func ajustmentsHealth():
	if Slime_type == 1:
		if health > 100:
			health = 100
	if Slime_type == 0:
		if health > 4000:
			health = 4000
	if health <= 0 :
		health = 0
		isAlive = false
		theSlimeHasNoHealth()

func _on_regin_timer_timeout():
	if Slime_type == 1:
		if health < 100:
			health +=20
			if health > 100:
				health = 100
		if health <= 0 :
			health = 0

func reginTimerPaused():
	if Main.gameStatus == "Pause":
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
	if AttackZone == true and canAttack == true and Main.gameStatus == "Start" and isAlive == true and Main.TalkingWithNPC == false:
		if Slime_type == 1:
			Main.playerHealth -= randi_range(7, 13)
		if Slime_type == 0:
			Main.playerHealth -= randi_range(1, 2)
		Main.enemyIsAttacking = true
		canAttack = false
		$canAttackCooldown.start()
		$enemyIsAttackingTime.start()
		await $enemyIsAttackingTime.timeout
		Main.enemyIsAttacking = false
		
func _on_can_attack_cooldown_timeout():
	canAttack = true

func deal_with_damage():
	if Main.playerCurrentAttack == true and AttackZone == true:
			health -= randi_range(150, 200)
			$canAttackCooldown.start()
			apply_knockback() 
			$AnimatedSprite2D.modulate = Color(1, 0, 0)
			var tweenModulate = get_tree().create_tween()
			tweenModulate.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.5)
			$reginTimer.start()
	
func enemy():
	pass
		

func apply_knockback(distance=10, time=0.2):
	var pos = self.position
	var player_pos = get_parent().get_node("player").position
	if Slime_type == 0: distance = 30
	
	var xb = pos.x - player_pos.x
	var yb = pos.y - player_pos.y
	
	var X = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * xb
	var Y = (1+ (distance/sqrt(pow(xb, 2) + pow(yb,2)) )) * yb
	
	var relative_new_coordinates = Vector2(X, Y)
	var new_coordinates = pos+relative_new_coordinates
	
	var collision = move_and_collide(relative_new_coordinates) # is null when nothing hit, else it is KinematicCollision2D
	if collision: # check if there is collision
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
		$CPUParticles2D.emitting = true
	if velocity == Vector2(0, 0):
		$CPUParticles2D.emitting = false 
	if velocity.x > 0:
		$CPUParticles2D.gravity = Vector2(-150, 0)
	if velocity.x < 0:
		$CPUParticles2D.gravity = Vector2(150, 0)
	if velocity.y > 0:
		$CPUParticles2D.gravity = Vector2(0, -150)
	if velocity.y < 0:
		$CPUParticles2D.gravity = Vector2(0, 150)

func _on_wait_to_walk_timeout():
	canWalk = true

func theSlimeHasNoHealth():
	$hitboxElements.disabled = true
	if Slime_type == 0:
		pass
	elif Slime_type == 1:
		$healthBar.visible = false
	velocity = Vector2(0, 0)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()
