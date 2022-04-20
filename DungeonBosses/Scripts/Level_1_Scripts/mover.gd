extends Node2D

export var move_speed = 200
export var gravity = 50
export var min_idle_time = 0.5
export var max_idle_time = 1.2

var idle_duration = rand_range(min_idle_time, max_idle_time)

var velocity = Vector2()

var dir = 1


func _process(delta):
	velocity.x = move_speed * dir
	
	if (dir == 1):
		$mover/AnimatedSprite.flip_h = false
	else:
		$mover/AnimatedSprite.flip_h = true
	
	$mover/AnimatedSprite.play("walk")
	velocity.y += gravity
	
	$mover.move_and_slide(Vector2(velocity.x, velocity.y), Vector2(0, -1))
	
	if ($mover.is_on_wall()):
		dir = dir * -1
		$mover/RayCast2D.position.x *= -1
	
	if ($mover/RayCast2D.is_colliding() == false):
		dir = dir * -1
		$mover/RayCast2D.position.x *= -1

func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		print("bullet entered")
		$mover/death_sound.play()
		$mover/CollisionShape2D.set_deferred("disabled", true)
		$mover/Area2D/CollisionShape2D.set_deferred("disabled", true)
		hide()
		body.queue_free()
		$mover/death.start()

func _on_death_timeout():
	queue_free()
