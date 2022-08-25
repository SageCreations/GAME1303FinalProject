extends Node2D

var start_pos
export var fire_ball_gravity = 0.1
export var max_fall_speed = 15.0
export var jump_force = 25.0
var y_vel = 0.0
var x_vel = 0.0


# dir should be 1(right) or -1(left)
func setup_fire_ball(pos, rot):
	position = pos
	rotation = rot
	start_pos = position.y


func _ready():
	randomize()
	y_vel = -jump_force
	


func _physics_process(delta):
	y_vel += fire_ball_gravity
	
	#if(get_parent() != null):
		#if (y_vel > 0 && $fire_ball/AnimatedSprite.flip_v == false):
		#	$fire_ball/AnimatedSprite.flip_v = true
		#if (y_vel < 0 && $fire_ball/AnimatedSprite.flip_v == true):
		#	$fire_ball/AnimatedSprite.flip_v = false
	
	if (y_vel > max_fall_speed):
		y_vel = max_fall_speed
		
	x_vel = rand_range(-1.0, 1.0)
	position.x += x_vel
	position.y += y_vel
		
