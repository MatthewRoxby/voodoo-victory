extends ColorRect

@onready var mat : ShaderMaterial = material

func _ready():
	trans_in(0.2, 0.5)

func tween_callback(a : float):
	mat.set_shader_parameter("amount", a)

func trans_in(delay_before : float, duration : float):
	
	mat.set_shader_parameter("amount", 1.0)
	mat.set_shader_parameter("flip", false)
	show()
	var t := create_tween()
	t.set_parallel(false)
	t.tween_interval(delay_before)
	t.tween_method(tween_callback, 1.0, 0.0, duration)
	await t.finished
	hide()

func trans_out(delay_after : float, duration : float):
	
	mat.set_shader_parameter("amount", 0.0)
	mat.set_shader_parameter("flip", true)
	show()
	var t := create_tween()
	t.set_parallel(false)
	t.tween_method(tween_callback, 0.0, 1.0, duration)
	t.tween_interval(delay_after)
	await t.finished
