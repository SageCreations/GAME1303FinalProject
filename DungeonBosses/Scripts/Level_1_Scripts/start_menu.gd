extends Control

# make variables for levels here
export(PackedScene) var level_one
export(PackedScene) var boss_level
export(PackedScene) var controls_level
export(PackedScene) var credits_level

# function to load scene called
func button_pressed(scene):
	get_tree().change_scene_to(scene)
	#get_tree().change_scene(scene)

 # function to quit window
func quit():
	get_tree().quit()

# start button
func _on_start_button_pressed():
	button_pressed(level_one)

# credits button
func _on_credits_button_pressed():
	button_pressed(credits_level)

# quit button
func _on_quit_button_pressed():
	quit()

# controls button
func _on_controls_button_pressed():
	button_pressed(controls_level)

# boss level button
func _on_boss_level_pressed():
	button_pressed(boss_level)
