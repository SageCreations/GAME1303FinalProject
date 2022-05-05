extends Node2D

var raise_door = false
var y_vel = 0
var dir = 0

export(int) var move_speed = 100

func _process(delta):
	if (raise_door):
		y_vel = move_speed * dir
	else:
		y_vel = move_speed * dir
		
		
		
	$door.move_and_slide(Vector2(0, y_vel), Vector2(0, dir))



func _on_Area2D_body_entered(body):
	if (body.get_name() == "Player"):
		raise_door = true
		dir = -1
		if ($door/door_open.playing == false):
			$door/door_open.set_deferred("playing", true)
		print(" door is raised")
		$door/door_close.set_deferred("playing", false)
		


func _on_Area2D_body_exited(body):
	if (body.get_name() == "Player"):
		raise_door = false
		dir = 1
		if ($door/door_close.playing == false):
			$door/door_close.set_deferred("playing", true)
		$door/door_open.set_deferred("playing", false)
