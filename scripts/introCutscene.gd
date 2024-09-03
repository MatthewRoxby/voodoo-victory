extends Control

func _ready():
	MusicController.change_song(load("res://sounds/music/medieval.wav"), 1.0)
	$skip.pressed.connect(skip)
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.queue("shot1")
	$AnimationPlayer.queue("shot2")
	$AnimationPlayer.queue("shot3")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func skip():
	$AnimationPlayer.pause()
	var t := create_tween()
	t.tween_property($skipTrans, "modulate", Color(1,1,1,1), 0.5)
	await t.finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
