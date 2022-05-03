extends Control

#buttons
onready var controls_back_button = $CanvasLayer/pause_menu_popup/PopupPanel/HBoxContainer/Button
onready var controls_button = $CanvasLayer/pause_menu_popup/VBoxContainer/controls_button
onready var quit_button = $CanvasLayer/pause_menu_popup/VBoxContainer/quit_button

#menus
onready var controls_panel = $CanvasLayer/pause_menu_popup/controls_panel
onready var pause_menu = $CanvasLayer/pause_menu_popup

#cooldown timer
onready var timer = $cooldown


func _ready():
	pause_menu.set_deferred("visible", false)
	controls_panel.set_deferred("visible", false)


func _process(delta):
	if (Input.is_action_pressed("pause_button") && timer.is_stopped()):
		get_tree().paused = !get_tree().paused
		if (get_tree().paused == true):
			pause_menu.set_deferred("visible", true)
		else:
			pause_menu.set_deferred("visible", false)
			controls_panel.set_deferred("visible", false)
			
		
		timer.start()


func _on_controls_button_pressed():
	controls_panel.set_deferred("visible", true)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_Button_pressed():
	controls_panel.set_deferred("visible", false)


func _on_start_menu_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
