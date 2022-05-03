extends Node2D


func _ready():
	randomize()
	
func game_over():
	#score = 0
	#$Player/HUD/MessageLabel.text = "Game Over"
	#$Player/HUD/MessageLabel.show_message()
	#$HUD.show_game_over()
	$Game_Music.stop()
	#$HUD.update_score(score)
	$Death_Sound.play()


func new_game():
	$Player.start($StartPosition.position)
	#$HUD/MessageLabel.show_message("Get Ready")
	$Game_Music.play()

