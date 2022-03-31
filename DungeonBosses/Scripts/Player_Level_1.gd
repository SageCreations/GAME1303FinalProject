extends KinematicBody2D

# https://www.youtube.com/watch?v=NScngW8vxK8
# code mostly from the video tutorial above.

# some consts made public so they can be edited in the editor
export var move_speed = 500
export var jump_force = 1000
export var gravity = 50
export var max_fall_speed = 1000

export (PackedScene) var bullet_scene

#onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var y_vel = 0
var facing_right = false
var bullet_dir

#function handles movement and jump
func _physics_process(delta):
	# left and right movement
	var move_dir = 0
	if Input.is_action_pressed("lvl_1_move_right"):
		move_dir += 1
	if Input.is_action_pressed("lvl_1_move_left"):
		move_dir -= 1
	move_and_slide(Vector2(move_dir * move_speed, y_vel), Vector2(0, -1))
	
	# jump
	var grounded = is_on_floor()
	y_vel += gravity
	if (grounded && Input.is_action_just_pressed("lvl_1_jump")):
		y_vel = -jump_force
	if (grounded && y_vel >= 5):
		y_vel = 5
	if (y_vel > max_fall_speed):
		y_vel = max_fall_speed
	
	# flip sprite direction, made it direct bullet direction too
	if (facing_right && move_dir < 0):
		flip()
	if (!facing_right && move_dir > 0):
		flip()
	
	if(facing_right):
		bullet_dir = 1
	else:
		bullet_dir = -1
	# shoot
	if (Input.is_action_just_pressed("lvl_1_shoot")):
		shoot(bullet_dir)
	
#	if (grounded):
#		if (move_dir == 0):
#			play_anim("idle")
#		else:
#			play_anim("walk")
#	else:
#		play_anim("jump")
	
# function for shooting	
func shoot(dir):
	var bullet = bullet_scene.instance()
	if (dir > 0):
		bullet.setup(Vector2(position.x+32, position.y), rotation, dir)
	else:
		bullet.setup(Vector2(position.x-64, position.y), rotation, dir)
	get_parent().add_child(bullet)
	
# function to flip sprite direction		
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
	
	
# function to deal with player run animation
# leave commented for now since im not using animations at the moment
#func play_anim(anim_name):
#	if (anim_player.is_playing() && anim_player.current_animation == anim_name):
#		return
#	anim_player.play(anim_name)
