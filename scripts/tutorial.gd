extends Control

var current_page := 0

@onready var pages := $Panel/Pages

@onready var numDisplay := $Panel/PageNum

var enabled := false

func set_page(x : int):
	current_page = clamp(x, 0, pages.get_child_count() - 1)
	
	if current_page == 7:
		SaveManager.save.done_tutorial = true
		SaveManager.write_save()
	
	numDisplay.text = str(current_page + 1) + "/" + str(pages.get_child_count())
	for i in range(pages.get_child_count()):
		pages.get_child(i).visible = i == current_page

func _ready():
	hide()
	set_page(0)
	$Panel/PreviousPage.pressed.connect(func(): set_page(current_page - 1))
	$Panel/NextPage.pressed.connect(func(): set_page(current_page + 1))
	$Panel/QuitTutorial.pressed.connect(func() : set_enabled(false))
	$Panel.scale = Vector2.ZERO

func set_enabled(b : bool):
	enabled = b
	if enabled:
		show()
		var t := create_tween()
		t.set_ease(Tween.EASE_OUT)
		t.set_trans(Tween.TRANS_BACK)
		t.tween_property($Panel, "scale", Vector2.ONE, 0.5)
		t.play()
	else:
		var t := create_tween()
		t.set_ease(Tween.EASE_IN)
		t.set_trans(Tween.TRANS_BACK)
		t.tween_property($Panel, "scale", Vector2.ZERO, 0.5)
		t.play()
		await t.finished
		hide()
