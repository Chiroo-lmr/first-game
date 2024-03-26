extends Node2D

var slime_boss = null

func spawn_boss():
	var SlimeScene = preload("res://scenes/character/slime/Slime.tscn")
	slime_boss = SlimeScene.instantiate()
	# we set some things so it looks like a real boss and not a normal slime
	slime_boss.apply_knockback = func(): return # it removes the knockback
	slime_boss.health *= 5 # we give it extra life
	slime_boss.scale.x *= 5
	slime_boss.scale.y *= 5
