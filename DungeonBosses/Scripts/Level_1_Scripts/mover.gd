extends Node2D


export var distance_movement = 192
var move_to = Vector2.RIGHT * distance_movement
export var speed = 200

export var min_idle_time = 0.5
export var max_idle_time = 1.2

var idle_duration = rand_range(min_idle_time, max_idle_time)


onready var mover = $mover
onready var tween = $Tween
onready var anim_sprite = $mover/AnimatedSprite


func _ready():
	_init_tween()
	anim_sprite.play("walk")
	

func _init_tween():
	var duration = move_to.length() / float(speed)
	randomize()
	idle_duration = rand_range(min_idle_time, max_idle_time)
	tween.interpolate_property(mover, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_duration)
	randomize()
	idle_duration = rand_range(min_idle_time, max_idle_time)
	tween.interpolate_property(mover, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + idle_duration * 2)
	tween.start()



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
