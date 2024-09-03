extends CanvasLayer

@onready var grayscale_mat : ShaderMaterial = $grayscale.material

func _ready():
	$"menu/Try Again".connect("pressed", try_again)
	$"menu/Main menu".connect("pressed", main_menu)
	MusicController.change_song(load("res://sounds/music/Wasteland Overdrive Looped.wav"), 1.0)
	hide()

func grayscale_callback(val : float):
	grayscale_mat.set_shader_parameter("circle_radius", val)

func scoreDisplay_callback(val : int):
	$menu/ScoreDisplay.text = str(val)

func start():
	MusicController.change_song(load("res://sounds/music/Death Is Just Another Path.ogg"), 0.8)
	grayscale_mat.set_shader_parameter("circle_radius", 1.1)
	$menu.modulate = Color(1,1,1,0)
	$menu/ScoreDisplay.text = "0"
	if %hiscore.score > %hiscore.hiscore:
		$menu/NewBest.show()
		SaveManager.save.high_score = %hiscore.score
		SaveManager.write_save()
	else:
		$menu/NewBest.hide()

	show()
	await get_tree().create_timer(2.0).timeout
	var t := create_tween()
	t.set_parallel(false)
	t.tween_method(grayscale_callback, 1.1, 0.0, 1.0)
	t.tween_property($menu, "modulate", Color(1,1,1,1), 0.5)
	t.tween_method(scoreDisplay_callback, 0, %hiscore.score, 3.0)
	

func try_again():
	await %transition.trans_out(0.2,0.5)
	get_tree().reload_current_scene()

func main_menu():
	await %transition.trans_out(0.2,0.5)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
