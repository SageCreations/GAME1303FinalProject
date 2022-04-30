extends Control

export(PackedScene) var start_menu_scene

func button_pressed(scene):
	get_tree().change_scene_to(scene)


func _on_Button_pressed():
	button_pressed(start_menu_scene)
