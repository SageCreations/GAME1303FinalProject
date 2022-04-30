extends KinematicBody2D

var raise_door = false
var y_vel = 0
var dir = 0

export var move_speed = 300

func _process(delta):
	if (raise_door):
		y_vel = move_speed * dir
	else:
		y_vel = move_speed * dir
		
		
		
	move_and_slide(Vector2(0, y_vel), Vector2(0, dir))



func _on_Area2D_body_entered(body):
	if (body.get_name() == "Player"):
		raise_door = true
		dir = -1
		print(" door is raised")
		


func _on_Area2D_body_exited(body):
	if (body.get_name() == "Player"):
		raise_door = false
		dir = 1
