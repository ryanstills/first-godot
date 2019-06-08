extends CanvasLayer
signal start_game

var high_score = 0

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$HighScore.show()
	$HighScoreButton.show()

func update_score(score):
	$Score.text = str(score)
	
func update_high_score(score):
	var file = File.new()
	if score > high_score:
		high_score = score
		file.open("user://saved_game.sav", File.WRITE)
		var data = {"high_score" : score}
	
		file.store_line(to_json(data))
		file.close()
		
	$HighScore.text = "High Score:\n " + str(high_score) 

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	$HighScore.hide()
	$HighScoreButton.hide()
	emit_signal("start_game")


func _on_HighScoreButton_pressed():
	var file = File.new()
	if not file.file_exists("user://saved_game.sav"):
		high_score = 0
	else:
		print("file exists")
		file.open("user://saved_game.sav", File.READ)
		print("opening saved game file")
		var data = {}
		data = parse_json(file.get_line())
		file.close()
		high_score = data["high_score"]
	update_high_score(high_score)
