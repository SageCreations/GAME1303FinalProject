extends Node2D

var in_range = false
export (PackedScene) var fire_ball_scene

export var fire_ball_spawn_x = 0
export var fire_ball_spawn_y = 0

var shoot_dir = 0
var shoot_allowed = true

export var min_shoot_time = 1.0
export var max_shoot_time = 2.0


onready var player = get_parent().get_parent().get_node("Player")

func _process(delta):
	if (in_range):
			
		if (player.position.x < position.x):
			shoot_dir = -1
		else:
			shoot_dir = 1
				
		if (shoot_allowed):
			shoot_fire_ball()



func shoot_fire_ball():
	var fire_ball = fire_ball_scene.instance()
	shoot_allowed = false
	randomize()
	var time = rand_range(min_shoot_time, max_shoot_time)
	$fire_ball_spawner/shoot_ready.start(time)
	fire_ball.setup_fire_ball(Vector2(position.x - fire_ball_spawn_x, position.y + fire_ball_spawn_y), rotation)
	get_parent().add_child(fire_ball)
	$shot_sound.play()


func _on_shoot_ready_timeout():
	shoot_allowed = true


func _on_VisibilityNotifier2D_screen_entered():
	in_range = true


func _on_VisibilityNotifier2D_screen_exited():
	in_range = false
