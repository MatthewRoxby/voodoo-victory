extends Node2D

@export var max_cooldown := 0.5
var cooldown := 0.0

var anim_one := true

@onready var animator := $AnimationPlayer
@onready var player_ref := $".."

@onready var swing_sound := $swing

func _ready():
	$hitbox.connect("body_entered", body_enter)

func body_enter(body):
	if body is Enemy:
		var dmg : int = %voodoo.calculate_damage(body)
		body.take_damage(player_ref.global_position, dmg)

func _process(delta):
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	
	cooldown -= delta
	if cooldown <= 0.0 and Input.is_action_pressed("attack") and player_ref.can_move and !player_ref.dead:
		animator.play("forth" if anim_one else "back")
		swing_sound.play_random()
		anim_one = !anim_one
		cooldown = max_cooldown
