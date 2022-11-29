extends RigidBody2D

export (float) var speed = 20.0
var start_pos
export (int) var distance = 300

func _ready():
	if (speed < 0):
		flip()

# dir should be 1(right) or -1(left)
func setup(pos, rot, dir):
	position = pos
	rotation = rot
	speed = dir * speed
	start_pos = position.x

func flip():
	$Sprite.flip_h = !$Sprite.flip_h

#position.x > start_pos-distance
func _physics_process(_delta):
	if (position.x < start_pos+distance && position.x > start_pos-distance):
		position.x += speed
	else:
		queue_free()



func _on_bullet_body_entered(body):
	#if(body):
		#queue_free()
	pass
