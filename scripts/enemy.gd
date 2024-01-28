extends CharacterBody2D
var speed = 35
var player_chase = false
var player = null
var health = 100
var playerAttackZone = false
var canTakeDamage = true
static var enemyID = 0

func _physics_process(delta):
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
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	 
func _on_detection_area_body_exited(body):
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
			health -= 20
			$takeDamageCooldown.start()
			canTakeDamage = false
			print("slime health = " + str(health))
			if health <=0 :
				enemyID += 1
				Global.addKilledEnemies(enemyID)
				print(Global.killed_enemies)
				queue_free()
				
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










