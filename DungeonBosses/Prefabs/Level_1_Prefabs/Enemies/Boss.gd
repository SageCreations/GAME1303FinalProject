extends KinematicBody2D

export var move_speed = 500
export var gravity = 50
export var max_fall_speed = 1000

var y_vel = 0
var facing_right = false

onready var anim = $AnimatedSprite

var is_dead = false


func _process(delta):
	if (!is_dead):
		pass
	
	
	y_vel += gravity

func _on_Area2D_body_entered(body):
	if (body.get_node() == "bullet"):
		pass
		#add func call for getting hit
		

		
#func for getting hit

#func for health (add or sub)

# try making movement only allowed when certain anim is playing,
# sort of like state machine.

# only let character move if run anim is on.

# before run anim can happen taunt needs to happen.

# when player is in certain distance have boss start 
# attack and give speed boost during the attack.

# let the bull have a idle timer and let it track the player in the mean time
# but have it standing still, at end of timer, let taunt happen and the charge
# continues over and over
