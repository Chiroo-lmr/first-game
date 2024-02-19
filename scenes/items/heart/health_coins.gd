extends Node2D


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		queue_free()
		Global.playerHealth += 50
