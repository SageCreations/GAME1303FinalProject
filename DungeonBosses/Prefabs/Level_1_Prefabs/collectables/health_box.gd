extends Node2D

func _on_Area2D_body_entered(body):
	if (body.get_name() == "Player"):
		print("player entered health_box")
		$health_pickup_sound.play()
		hide()
		$health_box/Area2D/CollisionShape2D.disabled = true
		$health_box/CollisionShape2D.disabled = true
		$despawn.start()
	
func _on_despawn_timeout():
	queue_free()
