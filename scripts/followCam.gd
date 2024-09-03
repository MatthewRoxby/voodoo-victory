extends Camera2D


@onready var player_ref := %player
@export var speed := 20.0
@export var mouse_influence := 20.0
@export var mouse_offset_speed := 20.0

@export var min_pos : Vector2
@export var max_pos : Vector2

var mouse_dir : Vector2

var off : Vector2
var pos : Vector2

func _process(delta):
	if player_ref:
		pos = lerp(pos, player_ref.global_position, speed * delta)
	
	mouse_dir = get_global_mouse_position() - get_screen_center_position()
	if mouse_dir.length() > 1:
		mouse_dir /= mouse_dir.length()
	off = lerp(off, Vector2(0,0) if player_ref.dead else mouse_dir * mouse_influence, delta * mouse_offset_speed)
	
	position.x = clamp(pos.x + off.x, min_pos.x, max_pos.x)
	position.y = clamp(pos.y + off.y, min_pos.y, max_pos.y)
