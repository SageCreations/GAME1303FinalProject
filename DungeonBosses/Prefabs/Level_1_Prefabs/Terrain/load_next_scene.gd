extends Node2D

# drop tab to manually choose what level the collider will send to
export(PackedScene) var next_level

# checkbox on whether the player needs to use input to load next level
export(bool) var input_needed = false

# boolean to make sure player is still overlapping the area2D collider
var input_valid : bool = false;

#listens for input events
func _input(event):
	if (Input.is_action_just_pressed("side_scroller_door")):
		if (input_valid):
			get_tree().change_scene_to(next_level)


func _on_Area2D_body_entered(body):
	# if body that belongs to the player enters
	if (body.get_name() == "Player"):
		# check for whether input is needed or not
		if (input_needed == true):
			input_valid = true;
		else:
			get_tree().change_scene_to(next_level)

# if input was needed but the body leaves, set the bool to false
func _on_Area2D_body_exited(body):
	if (body.get_name() == "Player"):
		input_valid = false
