extends Node2D

func _on_cliff_side_transition_point_body_entered(body):
	if body.has_method("player"):
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
		Global.currentScene = "cliffSide"


func _on_cliff_side_transition_point_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false

#func ChangeScene():
	#if Global.transitionScene == true:
			#get_tree().change_scene_to_file("res://scenes/ciff_side.tscn")
			#Global.gameFirstLoaded = false
			#Global.currentScene = "cliffSide"


func _on_cliff_side_2_transition_point_body_entered(body):
	if body.has_method("player"):
		Global.transitionScene = true
		get_tree().change_scene_to_file("res://scenes/cliff_side_2.tscn")
		Global.currentScene = "cliffSide2"
		print("bonjour")
	
func _on_cliff_side_2_transition_point_body_exited(body):
	if body.has_method("player"):
		Global.transitionScene = false
