extends CharacterBody2D
var speed = 30
var player_chase = false
var player = null
var health = 100
var playerAttackZone = false
var canTakeDamage = true

func _ready():
	pass
	
func _physics_process(delta):
	reginTimerPaused()
	if Global.gameStart == true:
		deal_with_damage()
		updateHealth()
		playerChase()

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true
		playerAttackZone = true 
	
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player = null
		player_chase = false
		playerAttackZone = false

func enemy():
	pass

func deal_with_damage():
	if playerAttackZone and Global.playerCurrentAttack == true:
		if canTakeDamage == true:
			health -= randi_range(15, 20)
			$takeDamageCooldown.start()
			canTakeDamage = false
			print("slime health = " + str(health))
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

func reginTimerPaused():
	if Global.gamePause == true:
		$reginTimer.paused = true
	else:
		$reginTimer.paused = false

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





