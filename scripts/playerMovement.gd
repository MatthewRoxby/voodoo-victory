extends CharacterBody2D

class_name Player

@export var max_speed := 10.0
@export var acceleration := 2.0
@export var deceleration := 1.0

@export var roll_max_cooldown := 2.0
var roll_cooldown := 0.0
@export var roll_vel := 30.0
var roll_dir : Vector2
@export var roll_duration := 1.0
var roll_time := 0.0
var rolling := false

var extra_forces : Vector2
@export var forces_damp := 1.0


@onready var sprite := $sprite
@onready var walk_particle := $walkParticle
@onready var roll_particle := $rollParticle

@onready var hit_sound := $hit
@onready var walk_sound := $walk
@onready var death_sound := $death
@onready var roll_sound := $roll

var vel : Vector2

var can_move := true

var health := 6
var knockback := 200.0
signal health_changed

@export var hitflash_duration := 0.5
var hitflash_time := 0.0
@onready var hitflash_mat : ShaderMaterial = $sprite.material

var dead := false

func take_damage(enemy_pos : Vector2):
	if rolling or hitflash_time > 0.0 or dead:
		return
	
	health -= 1
	
	if health == 0:
		death_sound.play()
		dead = true
		$AnimationPlayer.play("death")
		%"Death Screen".start()
	else:
		hit_sound.play()
		
	extra_forces = enemy_pos.direction_to(global_position) * knockback
	hitflash_time = hitflash_duration
	health_changed.emit(health)

func _process(delta):
	hitflash_mat.set_shader_parameter("strength", (hitflash_time / hitflash_duration))
	hitflash_time = max(hitflash_time - delta, 0.0)

func _physics_process(delta):
	if dead: return
	
	var inp := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	var moving := inp.length() > 0.1
	
	roll_cooldown -= delta
	if Input.is_action_just_pressed("roll") && roll_cooldown <= 0.0 && moving && can_move:
		roll_cooldown = roll_max_cooldown
		roll_time = roll_duration
		roll_dir = inp.normalized()
		roll_particle.look_at(roll_particle.global_position + roll_dir)
		roll_particle.restart()
		#start roll
		roll_sound.play_random()
		rolling = true
		set_collision_mask_value(3, false)
	
	if moving and !rolling:
		if !walk_sound.playing:
			walk_sound.play()
	else:
		walk_sound.stop()
	walk_particle.emitting = moving
	walk_particle.look_at(walk_particle.global_position + inp)
	
	if !rolling:
		if moving and can_move:
			sprite.play("walk")
			vel = vel.move_toward(inp * max_speed, delta * acceleration)
			sprite.rotation_degrees = lerp(sprite.rotation_degrees, inp.x * 10.0, delta * 10.0)
		else:
			sprite.play("idle")
			vel = vel.move_toward(Vector2.ZERO, delta * deceleration)
			sprite.rotation_degrees = lerp(sprite.rotation_degrees, 0.0, delta * 10.0)
	
	if roll_time >= 0.0:
		roll_time -= delta
		vel = vel.move_toward(roll_dir * roll_vel, 1000.0 * delta)
		sprite.play("roll")
		sprite.rotation_degrees += (2000.0 if roll_dir.x > 0 else -2000.0) * delta
	else:
		if rolling:
			#end roll
			rolling = false
			sprite.rotation_degrees = clamp(sprite.rotation_degrees, -10, 10)
			set_collision_mask_value(3, true)
	
	
	velocity = vel + extra_forces
	
	extra_forces = lerp(extra_forces, Vector2.ZERO, delta * forces_damp)
	
	move_and_slide()
