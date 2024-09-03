extends Node

var save : SaveFile

signal save_loaded

func _ready():
	if FileAccess.file_exists("user://save.tres"):
		save = ResourceLoader.load("user://save.tres")
	else:
		save = load("res://default_save.tres")
	await get_tree().process_frame
	save_loaded.emit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await write_save()

func write_save():
	ResourceSaver.save(save, "user://save.tres")
	print("finished save")

func reset_save():
	save = load("res://default_save.tres")
	write_save()
	save_loaded.emit()
