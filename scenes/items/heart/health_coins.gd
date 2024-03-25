extends Node2D


func _on_area_2d_body_entered(body):
	if body.has_method("player") and Main.playerHealth < 100:
		queue_free()
		Main.playerHealth += 50
