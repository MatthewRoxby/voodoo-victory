extends Node2D

@onready var spawner_container := $spawners

@onready var enemy_container := $enemies

var spawner_scene := preload("res://scenes/enemy_spawner.tscn")

@onready var player_ref : Player = %player as Player

var difficulty := 0

const MAX_DIFFICULTY := 100

@export var spawn_distance_from_player := 100.0

@export var difficulty_gain_time := 5.0
var difficulty_time := 0.0

@onready var difficulty_bar : TextureProgressBar = %DifficultyBar.get_child(0)

@export var spawn_times_min := 30.0
@export var spawn_times_max := 10.0
var spawn_time := 10.0

@export var spawn_number_min := 4
@export var spawn_number_max := 10

@export var matching_parts_min := 4
@export var matching_parts_max := 1

func get_enemies():
	return enemy_container.get_children()

func _ready():
	randomize()

func _process(delta):
	difficulty_bar.value = difficulty
	difficulty_time -= delta
	if difficulty_time < 0.0:
		difficulty_time = difficulty_gain_time
		difficulty = min(difficulty + 1, MAX_DIFFICULTY)
	
	spawn_time -= delta
	
	if spawn_time < 0.0:
		#make an enemy spawner
		var spawner : Node2D = null
		
		while(spawner == null):
			var s : Node2D = spawner_container.get_children().pick_random()
			if player_ref.global_position.distance_to(s.global_position) > spawn_distance_from_player:
				spawner = s
		
		var spawn_number = lerp(spawn_number_min, spawn_number_max, float(difficulty) / MAX_DIFFICULTY)
		var matching_parts = lerp(matching_parts_min, matching_parts_max, float(difficulty) / MAX_DIFFICULTY)
		
		spawner.begin(player_ref, enemy_container, spawn_number, matching_parts)
		
		spawn_time = lerp(spawn_times_min, spawn_times_max, float(difficulty) / MAX_DIFFICULTY)

