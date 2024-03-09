extends Node2D

func _on_collision_transition_scene_body_entered(body):
	if body.has_method("player"):
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/Maps/beginningScene/Beginning.tscn")
		Global.currentScene = "Beginning"
		Global.playerLivePosition = Vector2(30, 26)
func _on_collision_transition_scene_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false