extends Control

func button_pressed(scene):
	get_tree().change_scene(scene)


func _on_Button_pressed():
	button_pressed("res://_LevelScenes/start_menu.tscn")
