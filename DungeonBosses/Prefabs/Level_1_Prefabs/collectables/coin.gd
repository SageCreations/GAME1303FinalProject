extends Node2D

func _on_Area2D_body_entered(body):
	if (body.get_name() == "Player"):
		print("player entered coin")
		$coin_pickup.play()
		
		hide()
		$coin/Area2D/CollisionShape2D.disabled = true
		$coin/CollisionShape2D.disabled = true
		$despawn.start()
	
func _on_despawn_timeout():
	queue_free()
	

