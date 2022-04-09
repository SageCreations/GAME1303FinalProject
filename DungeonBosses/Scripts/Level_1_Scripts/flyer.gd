extends Node2D

const IDLE_DURATION = 0.7

export var move_to = Vector2.UP * 192
export var speed = 200

onready var flyer = $flyer
onready var tween = $Tween

func _ready():
	_init_tween()
	
func _init_tween():
	var duration = move_to.length() / float(speed)
	tween.interpolate_property(flyer, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(flyer, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()


func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		print("bullet entered")
		$flyer/death_sound.play()
		hide()
		$flyer/CollisionShape2D.set_deferred("disabled", true)
		$flyer/Area2D/CollisionShape2D.set_deferred("disabled", true)
		$flyer/death.start()


func _on_death_timeout():
	queue_free()
