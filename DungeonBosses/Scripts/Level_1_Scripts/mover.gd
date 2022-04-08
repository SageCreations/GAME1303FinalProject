extends Node2D


const IDLE_DURATION = 1.0

export var move_to = Vector2.RIGHT * 192
export var speed = 100

export (PackedScene) var bullet = null

onready var flyer = $mover
onready var tween = $Tween
onready var anim_sprite = $mover/AnimatedSprite
var player = null


func _ready():
	_init_tween()
	anim_sprite.play("walk")
	
	

func _init_tween():
	var duration = move_to.length() / float(speed)
	tween.interpolate_property(flyer, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(flyer, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()

