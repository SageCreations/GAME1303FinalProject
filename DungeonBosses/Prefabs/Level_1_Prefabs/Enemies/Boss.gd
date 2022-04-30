extends KinematicBody2D

export var move_speed = 800
export var move_speed_boost = 200
export var gravity = 50
export var max_fall_speed = 1000
export var jump_force = 1700
var has_jumped = false

var y_vel = 0
var x_vel = 0
var dir = 1

onready var anim = $AnimatedSprite
onready var effects_anim = $AnimationPlayer

var is_dead = false

export var boss_health = 30
var max_boss_health

var in_range = false

enum State {STATE_IDLE, STATE_TAUNT, STATE_WALK, STATE_ATTACK, STATE_DEAD}

var current_state = null

onready var player = get_parent().get_node("Player")

func _ready():
	$death_box.set_deferred("disabled", true)
	max_boss_health = boss_health

func _process(delta):
	if (!is_dead):
		if (current_state == State.STATE_IDLE):
			x_vel = 0
			# check for player direction to change where the boss is facing
			if (player.position.x < position.x):
				anim.flip_h = true
				$attack_range/CollisionShape2D.position.x = -72
				dir = -1
			else: 
				anim.flip_h = false
				$attack_range/CollisionShape2D.position.x = 72
				dir = 1

			anim.play("idle")
			if ($idle_timer.is_stopped()):
				$idle_timer.start()

		elif (current_state == State.STATE_TAUNT):
			x_vel = 0
			# keep checking for player direction here
			if (player.position.x < position.x):
				anim.flip_h = true
				$attack_range/CollisionShape2D.position.x = -72
				dir = -1
			else: 
				anim.flip_h = false
				$attack_range/CollisionShape2D.position.x = 72
				dir = 1
			
			if(anim.get_frame() == 10):
				set_state(State.STATE_WALK)
				
				

		elif (current_state == State.STATE_WALK):
			# lock boss direction at this point.
			# let the boss move x_axis wise now.
			anim.play("run")
			x_vel = move_speed * dir
			
			
			if (in_range):
				set_state(State.STATE_ATTACK)
			
			if(is_on_wall()):
				set_state(State.STATE_IDLE)

		elif (current_state == State.STATE_ATTACK):
			# give a speed boost to x_speed
			x_vel = (move_speed + move_speed_boost) * dir
			anim.play("attack")
			
			if(is_on_wall()):
				set_state(State.STATE_IDLE)
				
			if (is_on_floor()):
				if (boss_health <= max_boss_health/2 && has_jumped == false):
					if(player.position.x > position.x-100 && player.position.x < position.x+100):
						y_vel = -jump_force
						has_jumped = true
		
		
	else:
		set_state(State.STATE_DEAD)
		x_vel = 0
		
	if(current_state == State.STATE_DEAD):
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$attack_range/CollisionShape2D.set_deferred("disabled", true)
		$death_box.set_deferred("disabled", false)
		anim.play("death")
		if ($death_timer.is_stopped()):
			$death_timer.start()
			
	
	if (!is_on_floor()):
		y_vel += gravity
	
	move_and_slide(Vector2(x_vel, y_vel), Vector2(0, -1))



func _on_Area2D_body_entered(body):
	if (body.get_name() == "bullet"):
		_damage(1)
		body.queue_free()
		#add func call for getting hit
		print("bullet has entered boss")
		
		
func set_state(new_state):
	print("old state: " + str(current_state) + " ///////// " + "new state: " + str(new_state))
	current_state = new_state
	
		
#func for getting hit
func _damage(value):
	
	boss_health -= value
	if (boss_health == 0):
		is_dead = true
		anim
	else:
		if($effects_timer.is_stopped()):
			$effects_timer.start()
			effects_anim.play("hit")
		#effects_anim.play("damage")
	
	
	
	
# *************** Example from player ****************
#	if (invuln_timer.is_stopped()):
#		invuln_timer.start()
#		health -= amount
#		health_label.text = "Health: " + str(health)
#		if (health <= 0):
#			kill()
#		effects_anim.play("damage")
#		effects_anim.queue("invuln")

#func for health (add or sub)
	
func _get_health():
	return boss_health

# try making movement only allowed when certain anim is playing,
# sort of like state machine.

# only let character move if run anim is on.

# before run anim can happen taunt needs to happen.

# when player is in certain distance have boss start 
# attack and give speed boost during the attack.

# let the bull have a idle timer and let it track the player in the mean time
# but have it standing still, at end of timer, let taunt happen and the charge
# continues over and over


func _on_idle_timer_timeout():
	set_state(State.STATE_TAUNT)
	anim.play("taunt")
	has_jumped = false
	print("idle timer finished")


func _on_attack_range_body_entered(body):
	if (body.get_name() == "Player"):
		in_range = true
		print("Boss, in_range = true")
	else:
		print(str(body))


func _on_attack_range_body_exited(body):
	if (body.get_name() == "Player"):
		in_range = false
		print("Boss, in_range = false")
	else:
		print(str(body))


func _on_effects_timer_timeout():
	effects_anim.stop()


func _on_death_timer_timeout():
	get_tree().change_scene("res://_LevelScenes/win_scene.tscn")
