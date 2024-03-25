extends Node2D
var world = preload("res://scenes/Maps/beginningScene/Beginning.tscn").instantiate()

func _process(delta):
	print(Main.gameStatus)
	if world != null:
		if world.visible == true:
			print("oui c visible")
		else:
			print("nn c pas visible")
	
	if Main.playerHealth <= 0:
		$MusicStreamPlayer.playing = false
	if Main.gameStatus == "Launch":
		if world != null:
			world.visible = false
		$Main_menu.visible = true
	elif Main.gameStatus == "Start":
		if world != null:
			world.visible = true
		$Main_menu.visible = false
	if Main.is_restarting == true:
		print("hello")
		remove_child($World)
		$Main_menu.visible = false
		world = preload("res://scenes/Maps/beginningScene/Beginning.tscn").instantiate()
		add_child(world)
		world.visible = true
		Main.is_restarting = false
	if Main.is_menu_pressed == true:
		print("hi")
		$Main_menu.visible = true
		remove_child($World)
		
		Main.is_menu_pressed = false
		
