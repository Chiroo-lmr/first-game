extends CharacterBody2D
var speed = 35
var player_chase = false
var player = null
var health = 100
var playerAttackZone = false
var canTakeDamage = true

var not_red_at = 0

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
	
	
func _ready():
	pass
	
func _physics_process(delta):
	
	if Global.gamePause == true:
		$reginTimer.paused = true
	else:
		$reginTimer.paused = false
	if Global.gameStart == true and Global.gameOver == false and Global.gamePause == false:
		deal_with_damage()
		updateHealth()
		var direction = Vector2.ZERO
	
	if Global.gamePause == true:
		$reginTimer.paused = true
	else:
		$reginTimer.paused = false
	if Global.gameStart == true and Global.gameOver == false and Global.gamePause == false:
		
		if Time.get_unix_time_from_system ( ) > not_red_at:
			deal_with_damage()
			updateHealth()
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

		else:
			$AnimatedSprite2D.play("dammage")

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true
	 
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player = null
		player_chase = false
	
func enemy():
	pass
	
func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		playerAttackZone = true
		
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		playerAttackZone = false
		
func deal_with_damage():
	if playerAttackZone and Global.playerCurrentAttack == true:
		if canTakeDamage == true:
			health -= randi_range(15, 20)
			$takeDamageCooldown.start()
			canTakeDamage = false
			print("slime health = " + str(health))
			apply_knockback() # ---------------------------------------------------------------------------------------------
			not_red_at = Time.get_unix_time_from_system ( ) + 0.3
			if health <=0 :
				queue_free()
			$reginTimer.start()
				
func _on_take_damage_cooldown_timeout():
	canTakeDamage = true

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










