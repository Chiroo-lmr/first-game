extends Control

@onready var label = $HBoxContainer/Label
@onready var button = $HBoxContainer/Button

@export var action_name : String = ""

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	
func set_action_name():
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
		"ui_accept":
			label.text = "Interact"
		"information":
			label.text = "HUD"
			
func set_text_for_key():
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	print(action_name + action_keycode)
	button.text = action_keycode


func _on_button_toggled(toggled_on):
	if toggled_on:
		button.text = "Press Any Key..."
		set_process_unhandled_key_input(toggled_on)
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false 
				i.set_process_unhandled_key_input(false)
			
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()












