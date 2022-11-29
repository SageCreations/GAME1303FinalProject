extends Node2D

var start_pos
export var spike_gravity = 3
export var max_fall_speed = 15
var y_vel = 0

func _ready():
	pass

# dir should be 1(right) or -1(left)
func setup_falling_spike(pos, rot):
	position = pos
	rotation = rot
	start_pos = position.y

#
func _physics_process(_delta):
	if (y_vel < max_fall_speed):
		y_vel += spike_gravity
	else:
		y_vel = max_fall_speed
		
	position.y += y_vel
		
