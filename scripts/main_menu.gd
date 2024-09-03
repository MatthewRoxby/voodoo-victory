extends Control

func _ready():
	get_tree().paused = false
	$ui/menu/Play.pressed.connect(play)
	$ui/menu/Quit.pressed.connect(quit)
	$ui/menu/Tutorial.pressed.connect(tutorial)
	$ui/menu/Options.pressed.connect(options)
	$ui/menu/hiscore.text = "[rainbow][center]highscore: " + str(SaveManager.save.high_score)
	SaveManager.save_loaded.connect(save_loaded)
	MusicController.change_song(load("res://sounds/music/Loop_The_Old_Tower_Inn.wav"), 1.0)

func save_loaded():
	$ui/menu/hiscore.text = "[rainbow][center]highscore: " + str(SaveManager.save.high_score)

func play():
	if SaveManager.save.done_tutorial:
		await %transition.trans_out(0.2, 0.5)
		get_tree().change_scene_to_file("res://scenes/arena.tscn")
		SaveManager.write_save()
	else:
		$ui/menu/Play/FinishTutorial.show()
		await get_tree().create_timer(5.0).timeout
		$ui/menu/Play/FinishTutorial.hide()

func tutorial():
	$ui/menu/tutorial.set_enabled(true)

func quit():
	SaveManager.write_save()
	await %transition.trans_out(0.2, 0.5)
	get_tree().quit()

func options():
	$ui/menu/OptionsPanel.set_enabled(true)
