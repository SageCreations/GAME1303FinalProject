extends Node2D

export(PackedScene) var next_level

export(bool) var input_needed = false

func _on_Area2D_body_entered(body):
	if (body.get_name() == "Player"):
		print_debug("player has entered 'load next area' box")
		if (input_needed == true):
			print_debug("input is needed!")
			if(Input.is_action_just_pressed("hub_world_go_into")):
				print_debug("Correct button was pressed!!!")
				# TODO: this part isnt executing, maybe need a type of listener function (research)
				get_tree().change_scene_to(next_level)
		else:
			get_tree().change_scene_to(next_level)
