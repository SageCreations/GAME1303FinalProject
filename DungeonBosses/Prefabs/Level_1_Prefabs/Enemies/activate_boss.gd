extends Area2D

onready var boss_node = get_parent().get_node("boss")
onready var music_node = get_parent().get_node("music")

func _on_activate_boss_body_entered(body):
	if (body.get_name() == "Player"):
		if ($Timer.is_stopped()):
			$Timer.start()


func _on_Timer_timeout():
	boss_node.set_state(boss_node.State.STATE_IDLE)
	music_node.set_deferred("playing", true)
	queue_free()
