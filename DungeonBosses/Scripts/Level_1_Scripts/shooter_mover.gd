extends KinematicBody2D


# mover variabels
export var move_speed = 200
export var gravity = 50
export var min_idle_time = 0.5
export var max_idle_time = 1.2

var idle_duration = rand_range(min_idle_time, max_idle_time)

var velocity = Vector2()

var dir = 1

# shooter variables
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
#onready var player = get_parent().get_tree().get_root().get_node("Player")
	

func _process(delta):
	velocity.x = move_speed * dir
	
	if (dir == 1):
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
		
	
	$AnimatedSprite.play("walk")
	velocity.y += gravity
	
	move_and_slide(Vector2(velocity.x, velocity.y), Vector2(0, -1))
	
	if (is_on_wall()):
		dir = dir * -1
		$RayCast2D.position.x *= -1
	
	if ($RayCast2D.is_colliding() == false):
		dir = dir * -1
		$RayCast2D.position.x *= -1
		
	if (in_range):
			#problem might be from this block here
		if (player.position.x < position.x):
			shoot_dir = -1
		else:
			shoot_dir = 1
				
		if (shoot_allowed && !is_dead):
			shoot_allowed = false
			shoot(shoot_dir)



func shoot(player_dir):
	var bullet = bullet_scene.instance()
	shoot_allowed = false
	randomize()
	var time = rand_range(min_shoot_time, max_shoot_time)
	$shoot_ready.start(time)
	print("fired bullet to the " + str(player_dir))
	if (player_dir > 0):
		bullet.setup(Vector2(position.x + bullet_spawn_x, position.y + bullet_spawn_y), rotation, player_dir)
	else:
		bullet.setup(Vector2(position.x - bullet_spawn_x, position.y + bullet_spawn_y), rotation, player_dir)
	get_parent().add_child(bullet)


func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		#print("bullet entered")
		$death_sound.play()
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		hide()
		is_dead = true
		body.queue_free()
		$death.start()
		


func _on_death_timeout():
	queue_free()
	

func _on_shoot_ready_timeout():
	shoot_allowed = true


func _on_VisibilityNotifier2D_screen_entered():
	in_range = true
	#print("in_range was set to true")


func _on_VisibilityNotifier2D_screen_exited():
	in_range = false
	#print("in_range was set to false")

