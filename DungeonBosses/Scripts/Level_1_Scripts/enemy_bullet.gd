extends Node2D

export (float) var speed = 20.0
var start_pos
export (int) var distance = 300

func _ready():
	pass

# dir should be 1(right) or -1(left)
func setup(pos, rot, dir):
	position = pos
	rotation = rot
	speed = dir * speed
	start_pos = position.x


#position.x > start_pos-distance
func _physics_process(_delta):
	if (position.x < start_pos+distance && position.x > start_pos-distance):
		position.x += speed
	else:
		queue_free()


