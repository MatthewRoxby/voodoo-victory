extends CharacterBody2D

class_name Enemy

var head : VoodooPart.PART_TYPE
var legs : VoodooPart.PART_TYPE
var rarm : VoodooPart.PART_TYPE
var larm : VoodooPart.PART_TYPE

var player_ref : Player

@export var movespeed := 20.0

@onready var nav_agent := $NavigationAgent2D

@onready var anim := $AnimationPlayer

var v : Vector2

var hitflashMat : ShaderMaterial

@export var hitflash_duration := 0.2
var hitflash_time := 0.0

@export var knockback := 12.0

@export var slash_lerp_speed := 20.0

var extra_forces : Vector2

var health := 17

var dead := false

var accumulated_score := 0

@onready var hit_dull_sound := $hit_dull
@onready var hit_heavy_sound := $hit_heavy
@onready var dead_sound := $dead
@onready var walk_sound := $walk
@onready var slash_sound := $slashing

@onready var damageNumberPool : Node = get_tree().current_scene.get_node("%damageNumberPool")

func _ready():
	hitflashMat = ShaderMaterial.new()
	hitflashMat.shader = load("res://shaders/hitflash.gdshader")
	$sprite.material = hitflashMat
	nav_agent.velocity_computed.connect(vel_computed)
	
	$slash.connect("body_entered", slash_enter)
	
	walk_sound.pitch_scale = randf_range(0.8, 1.2)

func set_parts(_legs : int, _head : int, _rarm : int, _larm : int):
	$sprite/legs.frame = _legs
	legs = _legs
	$sprite/head.frame = _head
	head = _head
	$sprite/rarm.frame = _rarm
	rarm = _rarm
	$sprite/larm.frame = _larm
	larm = _larm

func slash_enter(body):
	if body is Player and !dead:
		body.take_damage(global_position)
		$slash/AnimatedSprite2D.play("slash")
		slash_sound.play_random()

func take_damage(player_pos : Vector2, damage: int):
	if hitflash_time > 0.0 or dead: return
	damageNumberPool.add_damage_number(global_position, damage)
	health -= damage
	accumulated_score += damage
	
	if damage > 4:
		hit_heavy_sound.play_random()
	else:
		hit_dull_sound.play_random()
	
	hitflash_time = hitflash_duration
	extra_forces += (player_pos.direction_to(global_position)) * knockback * damage
	
	if health <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		get_tree().current_scene.get_node("%hiscore").increase_score(accumulated_score)
		anim.play("death")
		dead = true
		nav_agent.set_deferred("avoidance_enabled", false)
		await anim.animation_finished
		queue_free()
	
	

func _process(delta):
	if player_ref:
		nav_agent.target_position = player_ref.global_position
		
		var a : float = (player_ref.global_position - global_position).angle() + (PI / 2.0)
		$slash.rotation = lerp_angle($slash.rotation, a, delta * slash_lerp_speed)
	
	extra_forces = lerp(extra_forces, Vector2.ZERO, delta * 4.0)
	hitflashMat.set_shader_parameter("strength", hitflash_time / hitflash_duration)
	hitflash_time = max(hitflash_time - delta, 0.0)
	
	if dead: return
	
	var moving : bool = get_real_velocity().length() > 10
	if moving:
		anim.play("walk")
	else:
		anim.play("idle")
	
	$walkParticle.look_at($walkParticle.global_position + velocity.normalized())
	$walkParticle.emitting = moving
	
	
	
	

func _physics_process(delta):
	var p : Vector2 = nav_agent.get_next_path_position()
	v = global_position.direction_to(p) * movespeed
	#nav_agent.get_next_path_position()
	nav_agent.velocity = v
	#move_and_slide()

func vel_computed(safe_velocity : Vector2):
	velocity = (safe_velocity + extra_forces) if !dead else extra_forces
	
	move_and_slide()
