extends KinematicBody2D

# https://www.youtube.com/watch?v=NScngW8vxK8
# code mostly from the video tutorial above.

signal hit
signal health_updated(health)
signal killed()

export (int) var start_health = 3
onready var health = start_health

# some consts made public so they can be edited in the editor
export var move_speed = 500
export var jump_force = 1000
export var gravity = 50
export var max_fall_speed = 1000

var spawn_point = Vector2(954, 100)
var start_level_position = spawn_point

# put the bullet prefab in this variable
export (PackedScene) var bullet_scene
# this is the distance added according to the player's position 
export (int) var bullet_spawn_x = 64
export (int) var bullet_spawn_y = 0

onready var anim_sprite = $AnimatedSprite
onready var sprite = $Sprite

onready var game_over_label = $HUD/CanvasLayer/CenterContainer/MessageLabel
onready var continue_button = $HUD/CanvasLayer/VBoxContainer/continue_button
onready var quit_button = $HUD/CanvasLayer/VBoxContainer/quit_button
onready var health_label = $HUD/CanvasLayer/health_container/HealthLabel
onready var coin_label = $HUD/CanvasLayer/score_container/ScoreLabel

var y_vel = 0
var facing_right = true
var bullet_dir
var shoot_allowed = true

var grounded 
var hit_ceiling

var renew_walk_sound = true

onready var invuln_timer = $invuln_timer
onready var effects_anim = $effects_animation

var is_dead = false

var amount_of_coins = 0
var coin_counter = 0
export var coin_amount_upgrade = 10

onready var boss = get_parent().get_node("boss")


func _ready():
	game_over_label.visible = false
	continue_button.visible = false
	quit_button.visible = false
	health_label.text = "Health: " + str(health)
	coin_label.text = "Coins: " + str(amount_of_coins)
	
	

#function handles all updated values
func _physics_process(_delta):
	if (is_dead == false):
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
			
			
		if (boss != null):
			$HUD/CanvasLayer/boss_container/boss_health_label.set_deferred("visible", true)
			$HUD/CanvasLayer/boss_container/boss_health_label.text = "Boss Health: " + str(boss._get_health())
		else:
			$HUD/CanvasLayer/boss_container/boss_health_label.set_deferred("visible", false)
	
	
	
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
	
func heal(amount):
	if (invuln_timer.is_stopped()):
		health += amount
		health_label.text = "Health: " + str(health)
		invuln_timer.start()
		effects_anim.play("heal")
		effects_anim.queue("invuln")
	
func damage(amount):
	if (invuln_timer.is_stopped()):
		invuln_timer.start()
		health -= amount
		health_label.text = "Health: " + str(health)
		if (health <= 0):
			kill()
		effects_anim.play("damage")
		effects_anim.queue("invuln")
	
func kill():
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$rectCollision.set_deferred("disabled", true)
	hide()
	is_dead = true
	game_over()


func _on_invuln_timer_timeout():
	effects_anim.play("rest")


func start(pos):
	position = pos
	show()



func game_over():
	
	game_over_label.visible = true
	continue_button.visible = true
	quit_button.visible = true
	
	continue_button.connect("pressed", self, "start_over")
	quit_button.connect("pressed", self, "quit")

func quit():
	get_tree().quit()

func start_over():
	get_tree().reload_current_scene()
	


func _on_Area2D_body_entered(body):
	if (body.get_name() == "mover"):
		print("mover enemy entered")
		damage(1)
	elif (body.get_name() == "flyer"):
		print("flyer enemy entered")
		damage(1)
	elif (body.get_name() == "shooter"):
		print("shooter enemy entered")
		damage(1)
	elif (body.get_name() == "shooter_mover"):
		print("shooter_mover enemy entered")
		damage(1)
	elif (body.get_name() == "shooter_flyer"):
		print("shooter_flyer enemy entered")
		damage(1)
	elif (body.get_name() == "enemy_bullet"):
		print("bullet from shooter type enemy entered")
		body.queue_free()
		damage(1)
	elif (body.get_name() == "spikes"):
		print("player got hit by spikes")
#		if (health > 0):
#			position = spawn_point
		damage(1)
	elif (body.get_name() == "lava"):
		print("player fell in lava")
		if (health > 0):
			position = spawn_point
		damage(1)
	elif (body.get_name() == "falling_spike"):
		print("player got hit by a falling spike")
		damage(1)
	elif (body.get_name() == "fire_ball"):
		print("player got hit by a fire_ball")
		damage(1)
	elif (body.get_name() == "hole"):
		print("player fell in hole")
		if (health > 0):
			position = spawn_point
		damage(1)
	elif (body.get_name() == "coin"):
		# update coin counter
		amount_of_coins += 1
		coin_counter += 1
		
		if (coin_counter == coin_amount_upgrade):
			heal(1)
			coin_counter = 0
			
		
		coin_label.text = "Coins: " + str(amount_of_coins)
		print("player picked up a coin")
		
	elif (body.get_name() == "health_box"):
		print("player picked up a health_box")
		heal(1)
		
	elif (body.get_name() == "checkpoint"):
		print("checkpoint space entered")
		spawn_point = body.get_parent().position       # .get_global_position()
	elif (body.get_name() == "boss"):
		print("player got hit by boss")
		damage(1)
		
	else: 
		print("Something strange entered the player; Object: " + str(body))
	

	
	
