extends Node2D

func _on_collision_transition_scene_body_entered(body):
	if body.has_method("player"):
		Main.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/Maps/beginningScene/Beginning.tscn")
		Main.currentScene = "Beginning"
		Main.playerLivePosition = Vector2(10, 15)
func _on_collision_transition_scene_body_exited(body):
	if body.has_method("player"):
		Main.transitionScene = false
