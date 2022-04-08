extends KinematicBody2D

# https://www.youtube.com/watch?v=NScngW8vxK8
# code mostly from the video tutorial above.

signal hit
signal health_updated(health)
signal killed()

export (int) var max_health = 3
onready var health = max_health

# some consts made public so they can be edited in the editor
export var move_speed = 500
export var jump_force = 1000
export var gravity = 50
export var max_fall_speed = 1000

# put the bullet prefab in this variable
export (PackedScene) var bullet_scene
# this is the distance added according to the player's position 
export (int) var bullet_spawn_x = 64
export (int) var bullet_spawn_y = 0

onready var anim_sprite = $AnimatedSprite
onready var sprite = $Sprite

var y_vel = 0
var facing_right = false
var bullet_dir
var shoot_allowed = true

var grounded 
var hit_ceiling

var renew_walk_sound = true

onready var invuln_timer = $invuln_timer
onready var effects_anim = $effects_animation

#function handles all updated values
func _physics_process(_delta):
	# left and right movement
	var move_dir = 0
	if Input.is_action_pressed("lvl_1_move_right"):
		move_dir += 1
	if Input.is_action_pressed("lvl_1_move_left"):
		move_dir -= 1
	move_and_slide(Vector2(move_dir * move_speed, y_vel), Vector2(0, -1))
	
	grounded = is_on_floor()
	if (move_dir != 0 && grounded && renew_walk_sound):
		renew_walk_sound = false
		$walk_sound.play()
		$walk_sound_timer.start()
	
	# jump code
	# moved grounded initialization up for walking sound code
	hit_ceiling = is_on_ceiling()
	y_vel += gravity
	if (grounded && Input.is_action_just_pressed("lvl_1_jump")):
		y_vel = -jump_force
		$jump_sound.play()
	if(!hit_ceiling):
		if (grounded && y_vel >= 5):
			y_vel = 5
		if (y_vel > max_fall_speed):
			y_vel = max_fall_speed
	else:
		y_vel = 1
	
	
	# flip sprite direction, made it direct bullet direction too
	if (facing_right && move_dir < 0):
		flip()
	if (!facing_right && move_dir > 0):
		flip()

	# shoot code
	if(facing_right):
		bullet_dir = 1
	else:
		bullet_dir = -1

	if (Input.is_action_just_pressed("lvl_1_shoot") && shoot_allowed == true):
		shoot(bullet_dir)
		$shotgun_sound.play()
		shoot_allowed = false
		$shot_timer.start()
	
	# control animation playing 
	if (grounded):
		if (move_dir == 0):
			anim_sprite.play("idle")
		else:
			anim_sprite.play("walk")
	else:
		anim_sprite.play("jump")
	
	
# function for shooting	
func shoot(dir):
	var bullet = bullet_scene.instance()
	if (dir > 0):
		bullet.setup(Vector2(position.x + bullet_spawn_x, position.y + bullet_spawn_y), rotation, dir)
	else:
		bullet.setup(Vector2(position.x - bullet_spawn_x, position.y + bullet_spawn_y), rotation, dir)
	get_parent().add_child(bullet)
	
# function to flip sprite direction		
func flip():
	facing_right = !facing_right
	anim_sprite.flip_h = !anim_sprite.flip_h
	
	
# function to deal with player run animation
# leave commented for now since im not using animations at the moment
#func play_anim(anim_name):
#	if (anim_player.is_playing() && anim_player.current_animation == anim_name):
#		return
#	anim_player.play(anim_name)

# timer to reset the shoot_allowed bool
func _on_shot_timer_timeout():
	shoot_allowed = true

func _on_walk_sound_timer_timeout():
	renew_walk_sound = true
	
	
func damage(amount):
	if (invuln_timer.is_stopped()):
		invuln_timer.start()
		_set_health(health - amount)
		effects_anim.play("damage")
		effects_anim.queue("invuln")
	
func kill():
	pass
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if (health != prev_health):
		emit_signal("health_updated", health) 
		if (health == 0):
			kill()


func _on_invuln_timer_timeout():
	effects_anim.play("rest")





func _on_Area2D_body_entered(body):
	body
