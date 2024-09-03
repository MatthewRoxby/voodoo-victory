extends Node2D

var value := 6

@onready var ogpos := position
var shake_strength := 10.0
var shake := 0.0

func set_health(health):
	if value > health:
		#taken damage
		shake = shake_strength
		
	elif value < health:
		#healed
		$heal.restart()
	value = health
	$"1".frame = clamp(health, 0, 2)
	$"2".frame = clamp(health - 2, 0, 2)
	$"3".frame = clamp(health - 4, 0, 2)

func _ready():
	set_health(6)
	%player.connect("health_changed", set_health)

func _process(delta):
	shake = lerp(shake, 0.0, delta * 5.0)
	position = ogpos + Vector2.from_angle(deg_to_rad(randi() % 360)) * shake
	
	#if Input.is_action_just_pressed("attack"):
		#set_health(value - 1)
	#if Input.is_action_just_pressed("roll"):
		#set_health(value + 1)
