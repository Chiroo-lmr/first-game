extends CharacterBody2D


var is_ready = false

var health = 150
var AttackZone = false
@onready var player = $player

func _ready():
	position = Vector2(-272, 103.75)
	is_ready = true
	
func _on_enemy_hitbox_combat_body_entered(body):
	if body.has_method("player"):
		AttackZone = true
		
func _on_enemy_hitbox_combat_body_exited(body):
	if body.has_method("player"):
		AttackZone = false


func _physics_process(delta):
	deal_with_damage()
	# slide to the player
	if is_ready:
		var tween = create_tween()
		tween.tween_property(self,"position",player.position,0.5)
		tween.tween_callback(
			func end_movement():
				self.position = player.position
		)
	
	
func deal_with_damage():
	if Main.playerCurrentAttack == true and AttackZone == true:
			health -= randi_range(150, 200)
			$canAttackCooldown.start()
			$AnimatedSprite2D.modulate = Color(1, 0, 0)
			var tweenModulate = get_tree().create_tween()
			tweenModulate.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.5)
	
