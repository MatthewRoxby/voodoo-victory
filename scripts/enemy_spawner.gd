@tool
extends Node2D

var enemy_scene := preload("res://scenes/enemy.tscn")

const POSSIBLE_PARTS := ["legs", "rarm", "larm", "head"]

@export var radius : float = 64.0

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		draw_arc(Vector2.ZERO, radius, 0.0, PI * 2.0, 24, Color.RED, 2.0)

func begin(player_ref : Player, enemy_container : Node2D, spawn_num : int, matching_parts : int):

	var matches := {}
	while len(matches) < matching_parts:
		var p : String = POSSIBLE_PARTS.pick_random()
		if !matches.has(p):
			matches[p] = randi() % 3
	
	for i in range(spawn_num):
		var enemy : Enemy = enemy_scene.instantiate()
		enemy.player_ref = player_ref
		enemy.set_parts(
			matches["legs"] if matches.has("legs") else randi() % 3,
			matches["head"] if matches.has("head") else randi() % 3,
			matches["rarm"] if matches.has("rarm") else randi() % 3,
			matches["larm"] if matches.has("larm") else randi() % 3
		)
		
		var a := deg_to_rad(randi() % 360)
		enemy.position = global_position + Vector2.from_angle(a) * randf_range(0, radius - 10.0)
		enemy_container.add_child(enemy)
	
	queue_free()
