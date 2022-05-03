extends Control



func button_pressed(scene):
	#get_tree().change_scene_to(scene)
	get_tree().change_scene(scene)


func quit():
	get_tree().quit()


func _on_start_button_pressed():
	button_pressed("res://_LevelScenes/Level_1.tscn")


func _on_credits_button_pressed():
	button_pressed("res://_LevelScenes/credits.tscn")


func _on_quit_button_pressed():
	quit()


func _on_controls_button_pressed():
	button_pressed("res://_LevelScenes/controls.tscn")
