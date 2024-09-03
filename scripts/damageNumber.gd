extends Node2D

@export var duration := 2.0
@export var displacement : Vector2
@export var fade_time := 0.3

var pool : Node2D

func anim(text : String):
	modulate = Color(1,1,1,0)
	$Label.text = text
	show()
	
	var t2 := create_tween()
	t2.set_parallel(false)
	t2.tween_property(self, "modulate", Color(1,1,1,1), fade_time)
	t2.tween_interval(duration - fade_time * 2.0)
	t2.tween_property(self, "modulate", Color(1,1,1,0), fade_time)
	t2.play()
	
	var t := create_tween()
	t.tween_property(self, "position", position + displacement, duration)
	t.play()
	await t.finished
	hide()
	pool.free_instance(self)
