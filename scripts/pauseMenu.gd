extends CanvasLayer

var enabled := false

@onready var pause_modulator := $pause
@onready var blur_mat : ShaderMaterial = $"pause blur".material

@onready var player_ref := %player

func _ready():
	$pause/Resume.pressed.connect(resume)
	$pause/Options.pressed.connect(func() : $pause/OptionsPanel.set_enabled(true))
	$"pause/Main menu".pressed.connect(
		func(): 
			SaveManager.write_save()
			await %transition.trans_out(0.2, 0.5)
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	)
	pause_modulator.hide()
	$"pause blur".hide()

func _input(event):
	if event.is_action_pressed("pause") and !player_ref.dead:
		set_enabled(!enabled)

func blur_tween(v : float):
	blur_mat.set_shader_parameter("strength", v)

func resume():
	set_enabled(false)

func set_enabled(b : bool):
	enabled = b
	
	if enabled:
		pause_modulator.modulate.a = 0
		blur_mat.set_shader_parameter("strength", 0)
		get_tree().paused = true
		pause_modulator.show()
		$"pause blur".show()
		var t := create_tween()
		t.set_parallel(true)
		#t.tween_property(blur_mat, "shader_parameter/strength", 0.01, 0.3)
		t.tween_method(blur_tween, 0.0, 0.01, 0.3)
		t.tween_property(pause_modulator, "modulate", Color(1,1,1,1), 0.5)
		t.play()
	else:
		pause_modulator.modulate.a = 1
		blur_mat.set_shader_parameter("strength", 0.01)

		var t := create_tween()
		t.set_parallel(true)
		#t.tween_property(blur_mat, "shader_parameter/strength", 0.0, 0.5)
		t.tween_method(blur_tween, 0.01, 0.0, 0.5)
		t.tween_property(pause_modulator, "modulate", Color(1,1,1,0), 0.3)
		t.play()
		await t.finished
		pause_modulator.hide()
		$"pause blur".hide()
		get_tree().paused = false
