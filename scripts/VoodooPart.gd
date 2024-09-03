extends Area2D

class_name VoodooPart

enum PART_TYPE{
	RED = 0,
	GREEN = 1,
	BLUE = 2
}

var target_position : Vector2
@export var mouse_lerp_speed := 30.0
@export var return_lerp_speed := 10.0

@onready var rest_pos := global_position

@onready var interface := %voodoo

var mouse_offset : Vector2

var hovered := false
var pressed := false
var fixed := false

@export var fixed_distance := 40.0
@export var pull_strength := 0.05

func _ready():
	connect("mouse_entered", func(): hovered = true)
	connect("mouse_exited", func(): hovered = false)
	$cover.modulate.a = 0.0

func cover_alpha(a : float):
	$cover.modulate.a = a

func switch_mat(col : PART_TYPE, mat : Material, actual_col : Color):
	$cover.material.set_shader_parameter("col", actual_col)
	var t := create_tween()
	t.tween_method(cover_alpha, 0.0, 1.0, 0.2)
	await t.finished
	$Sprite2D.material = mat
	var t2 := create_tween()
	t2.tween_method(cover_alpha, 1.0, 0.0, 0.2)
	interface.set_part_colour(name, col)

func _process(delta):
	#print(fixed)
	if Input.is_action_just_pressed("click"):
		if hovered:
			$"../../rip".play_random()
			pressed = true
			mouse_offset = position - get_global_mouse_position()
	
	if Input.is_action_just_released("click"):
		if pressed:
			pressed = false
	
	if pressed:
		if fixed:
			var l := (get_global_mouse_position() - (position - mouse_offset))
			
			target_position = position + (l * pull_strength)
			print(target_position)
			position = lerp(position, target_position, delta * mouse_lerp_speed)
			if position.distance_to(rest_pos) > fixed_distance:
				fixed = false
		else:
			target_position = get_global_mouse_position()
			position = lerp(position, target_position + mouse_offset, delta * mouse_lerp_speed)
		
	else:
		target_position = rest_pos
		mouse_offset = Vector2.ZERO
		position = lerp(position, target_position + mouse_offset, delta * return_lerp_speed)
		if position.distance_to(rest_pos) < fixed_distance:
			#fixed = true
			pass
	
	
