extends Node2D


const IDLE_DURATION = 0.7

export var move_to = Vector2.RIGHT * 192
export var speed = 200

export (PackedScene) var bullet = null

onready var mover = $mover
onready var tween = $Tween
onready var anim_sprite = $mover/AnimatedSprite


func _ready():
	_init_tween()
	anim_sprite.play("walk")
	
	

func _init_tween():
	var duration = move_to.length() / float(speed)
	tween.interpolate_property(mover, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(mover, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()





func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		print("bullet entered")
		$mover/death_sound.play()
		$mover/CollisionShape2D.set_deferred("disabled", true)
		$mover/Area2D/CollisionShape2D.set_deferred("disabled", true)
		hide()
		$mover/death.start()


func _on_death_timeout():
	queue_free()
