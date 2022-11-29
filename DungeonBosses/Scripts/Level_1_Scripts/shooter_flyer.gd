extends KinematicBody2D

# mover variables
export var distance_from_origin = 200
export var move_speed = 100

var dir = 1
var velocity = Vector2()

export var min_idle_time = 1.0
export var max_idle_time = 1.5

var idle_duration = rand_range(min_idle_time, max_idle_time)

onready var start_y_pos = position.y

var switch_dir = true

# shooter variable
var in_range = false
export (PackedScene) var bullet_scene

export var bullet_spawn_x = 32
export var bullet_spawn_y = 0

var shoot_dir = 0
var shoot_allowed = true

export var min_shoot_time = 1.0
export var max_shoot_time = 2.0

var is_dead = false
var facing_left = true

onready var player = get_parent().get_parent().get_parent().get_node("Player")

func _ready():
	pass


func _process(delta):
	if (dir == 1 && position.y < start_y_pos + distance_from_origin):
		velocity.y = move_speed * dir
	elif(dir == -1 && position.y > start_y_pos - distance_from_origin):
		velocity.y = move_speed * dir
	else:
		velocity.y = 0
		if (switch_dir):
			switch_dir = false
			randomize()
			idle_duration = rand_range(min_idle_time, max_idle_time)
			$idle_timer.start(idle_duration)
			
	move_and_slide(Vector2(0, velocity.y), Vector2(0, dir))
	
	if (shoot_dir == 1 && facing_left == true):
		$Sprite.flip_h = true
		facing_left = false
		
	if (shoot_dir == -1 && facing_left == false):
		$Sprite.flip_h = false
		facing_left = true
	
	if (in_range):
		if (player.position.x < get_parent().position.x):
			shoot_dir = -1
		else:
			shoot_dir = 1
				
		if (shoot_allowed && !is_dead):
			shoot_allowed = false
			shoot(shoot_dir)


func shoot(dir):
	var bullet = bullet_scene.instance()
	shoot_allowed = false
	randomize()
	var time = rand_range(min_shoot_time, max_shoot_time)
	$shoot_ready.start(time)
	if (dir > 0):
		bullet.setup(Vector2(position.x + bullet_spawn_x, position.y + bullet_spawn_y), rotation, dir)
	else:
		bullet.setup(Vector2(position.x - bullet_spawn_x, position.y + bullet_spawn_y), rotation, dir)
	get_parent().add_child(bullet)
	$shoot_sound.play()


func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		is_dead = true
		$death_sound.play()
		hide()
		body.queue_free()
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$death.start()


func _on_death_timeout():
	queue_free()


func _on_idle_timer_timeout():
	dir = dir * -1
	switch_dir = true
	
	
func _on_VisibilityNotifier2D_screen_entered():
	in_range = true
	


func _on_VisibilityNotifier2D_screen_exited():
	in_range = false
	


func _on_shoot_ready_timeout():
	shoot_allowed = true
