extends Panel

var enabled := false

func _ready():
	$QuitOptions.pressed.connect(func(): set_enabled(false))
	$MusicSlider.value_changed.connect(music_slider_value_changed)
	$SfxSlider.value_changed.connect(sfx_slider_value_changed)
	$DeleteData.pressed.connect(func(): SaveManager.reset_save())
	
	scale = Vector2.ZERO
	SaveManager.save_loaded.connect(on_saveFile_load)
	#await get_tree().process_frame
	on_saveFile_load()
	hide()

func on_saveFile_load():
	print("loading volumes: " , SaveManager.save.music_volume, SaveManager.save.sfx_volume)
	$MusicSlider.value = SaveManager.save.music_volume
	$SfxSlider.value = SaveManager.save.sfx_volume

func music_slider_value_changed(value : float):
	var p : int = value * 100
	$MusicSlider/Value.text = "Music: " + str(p) + "%"
	
	SaveManager.save.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func sfx_slider_value_changed(value : float):
	var p : int = value * 100
	$SfxSlider/Value.text = "SFX: " + str(p) + "%"
	SaveManager.save.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func set_enabled(b : bool):
	enabled = b
	if enabled:
		show()
		var t := create_tween()
		t.set_ease(Tween.EASE_OUT)
		t.set_trans(Tween.TRANS_BACK)
		t.tween_property(self, "scale", Vector2.ONE, 0.5)
		t.play()
	else:
		var t := create_tween()
		t.set_ease(Tween.EASE_IN)
		t.set_trans(Tween.TRANS_BACK)
		t.tween_property(self, "scale", Vector2.ZERO, 0.5)
		t.play()
		await t.finished
		hide()
