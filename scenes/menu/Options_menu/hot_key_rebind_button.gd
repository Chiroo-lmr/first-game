extends Control

@onready var label = $HBoxContainer/Label
@onready var button = $HBoxContainer/Button
@export var action_name : String = ""
var can_listen = false
var action_keycode
var button_index
var mouse_keycode

func _ready():
	set_process_unhandled_key_input(false)
	set_text_for_key()
			
func _process(delta):
	if button.button_pressed == true:
		can_listen = true
	else:
		can_listen = false
	
	
func set_text_for_key():
	label.text = "unassigned"
	match action_name:
		"ui_left":
			label.text = "Move Left"
		"ui_right":
			label.text = "Move Right"
		"ui_up":
			label.text = "Move Up"
		"ui_down":
			label.text = "Move Down"
		"attack":
			label.text = "Attack"
		"ui_cancel":
			label.text = "Escape"
		"information":
			label.text = "HUD"
	var action_events = InputMap.action_get_events(action_name)
	button.text = action_events[0].as_text().trim_suffix(" (Physical)").trim_suffix(" (Button)")

func _on_button_toggled(toggled_on):
	if toggled_on:
		button.text = "Press Any Key..."
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.disabled = true
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.disabled = false
		set_text_for_key()

func _on_timer_timeout():
	$HBoxContainer/alread_assigned.visible = false
	
func _input(event):
	if can_listen == true:
		if event is InputEventKey:
			var is_duplicate = false
			while true:
				for i in get_tree().get_nodes_in_group("hotkey_button"):
					if i.action_name!=self.action_name:
						if i.button.text=="%s" %OS.get_keycode_string(event.physical_keycode):
							is_duplicate=true
							$HBoxContainer/alread_assigned.visible = true
							$Timer.start()
							button.button_pressed = false
				break
			if not is_duplicate:
				InputMap.action_erase_events(action_name)
				InputMap.action_add_event(action_name,event)
				set_text_for_key()
				$HBoxContainer/alread_assigned.visible = false
				button.button_pressed = false
				action_keycode = OS.get_keycode_string(event.physical_keycode)
		accept_event()
		if event is InputEventMouseButton and event.button_index != 5 and event.button_index != 4:
			if event.double_click == true:
				event.double_click = false
			var is_duplicate = false
			button_index = event.button_index
			match button_index:
				1:
					mouse_keycode = "Left Mouse Button"
				2:
					mouse_keycode = "Right Mouse Button"
				3:
					mouse_keycode = "Middle Mouse Button"
				8:
					mouse_keycode = "Mouse Thumb Button 1"
				9:
					mouse_keycode = "Mouse Thumb Button 2"
			while true:
				for i in get_tree().get_nodes_in_group("hotkey_button"):
					if i.action_name!=self.action_name:
						if i.button.text=="%s" %mouse_keycode:
							is_duplicate=true
							$HBoxContainer/alread_assigned.visible = true
							$Timer.start()
							button.button_pressed = false
				break
			if not is_duplicate:
				InputMap.action_erase_events(action_name)
				InputMap.action_add_event(action_name,event)
				set_text_for_key()
				$HBoxContainer/alread_assigned.visible = false
				button.button_pressed = false
		accept_event()
