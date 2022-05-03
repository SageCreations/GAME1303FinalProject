extends Node2D


var in_range = false
export (PackedScene) var bullet_scene

export var bullet_spawn_x = 32
export var bullet_spawn_y = 32

var shoot_dir = 0
var shoot_allowed = true

export var min_shoot_time = 1.0
export var max_shoot_time = 2.0

var is_dead = false

onready var player = get_parent().get_parent().get_node("Player")

func _process(delta):
	if (in_range):
			
		if (player.position.x < position.x):
			shoot_dir = -1
		else:
			shoot_dir = 1
				
		if (shoot_allowed && !is_dead):
			shoot(shoot_dir)



func shoot(dir):
	var bullet = bullet_scene.instance()
	shoot_allowed = false
	randomize()
	var time = rand_range(min_shoot_time, max_shoot_time)
	$shooter/shoot_ready.start(time)
	if (dir > 0):
		bullet.setup(Vector2(position.x + bullet_spawn_x, position.y + bullet_spawn_y), rotation, dir)
	else:
		bullet.setup(Vector2(position.x - bullet_spawn_x, position.y + bullet_spawn_y), rotation, dir)
	get_parent().add_child(bullet)
	$shooter/shoot_sound.play()
	
		

func _on_shoot_ready_timeout():
	shoot_allowed = true




func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		print("bullet entered")
		$shooter/death_sound.play()
		$shooter/CollisionShape2D.set_deferred("disabled", true)
		$shooter/Area2D/CollisionShape2D.set_deferred("disabled", true)
		hide()
		is_dead = true
		body.queue_free()
		$shooter/death.start()


func _on_death_timeout():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	in_range = true
	print("in_range was set to true")


func _on_VisibilityNotifier2D_screen_exited():
	in_range = false
	print("in_range was set to false")

