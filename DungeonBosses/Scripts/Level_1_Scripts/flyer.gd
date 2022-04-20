extends KinematicBody2D

export var distance_from_origin = 200
export var move_speed = 100

var dir = 1
var velocity = Vector2()

export var min_idle_time = 1.0
export var max_idle_time = 1.5

var floor_normal = Vector2.UP

var idle_duration = rand_range(min_idle_time, max_idle_time)

onready var start_y_pos = position.y

var switch_dir = true


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
	


func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		print("bullet entered")
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
	
