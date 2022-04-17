extends Node2D



export var distance_movement = 192
var move_to = Vector2.UP * distance_movement
export var speed = 200

export var min_idle_time = 0.5
export var max_idle_time = 1.2

var idle_duration = rand_range(min_idle_time, max_idle_time)

onready var flyer = $flyer
onready var tween = $Tween

func _ready():
	_init_tween()
	
func _init_tween():
	var duration = move_to.length() / float(speed)
	randomize()
	idle_duration = rand_range(min_idle_time, max_idle_time)
	tween.interpolate_property(flyer, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_duration)
	randomize()
	idle_duration = rand_range(min_idle_time, max_idle_time)
	tween.interpolate_property(flyer, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + idle_duration * 2)
	tween.start()


func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		print("bullet entered")
		$flyer/death_sound.play()
		hide()
		body.queue_free()
		$flyer/CollisionShape2D.set_deferred("disabled", true)
		$flyer/Area2D/CollisionShape2D.set_deferred("disabled", true)
		$flyer/death.start()


func _on_death_timeout():
	queue_free()
