extends Area2D

@export var colour : Color
@export var colEnum : VoodooPart.PART_TYPE
@export var mat : ShaderMaterial

func _ready():
	connect("area_entered", enter)

func enter(area):
	if area is VoodooPart and area.get("pressed") == true:
		$burst.restart()
		$"../../blast".play_random()
		$"../../submerge".play_random()
		area.call("switch_mat", colEnum, mat, colour)
