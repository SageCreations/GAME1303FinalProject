extends Node2D

export var IDLE_DURATION = 1.0

export var move_to = Vector2.RIGHT * -192
export var speed = 100

onready var diagonal_platform = $platform
onready var tween = $Tween


func _ready():
	_init_tween()


func _init_tween():
	var duration = move_to.length() / float(speed)
	tween.interpolate_property(diagonal_platform, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(diagonal_platform, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()
