extends Control

export(PackedScene) var level_1_scene
export(PackedScene) var credits_scene
export(PackedScene) var controls_scene

func button_pressed(scene):
	get_tree().change_scene_to(scene)


func quit():
	get_tree().quit()


func _on_start_button_pressed():
	button_pressed(level_1_scene)


func _on_credits_button_pressed():
	button_pressed(credits_scene)


func _on_quit_button_pressed():
	quit()


func _on_controls_button_pressed():
	button_pressed(controls_scene)
