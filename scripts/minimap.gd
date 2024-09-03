extends Panel

@onready var enemy_mark_prefab := $radar/enemyMark
@onready var wave_manager_ref := %waveManager

@onready var player_ref := %player

@export var max_distance := 200.0

@export var real_max_distance := 25.0

@onready var enemies_container := $enemies

func _process(delta):
	var arr : Array[Node] = wave_manager_ref.get_enemies()
	for i in enemies_container.get_children():
		i.hide()
	
	for i in range(len(arr)):
		var c = arr[i] as Node2D
		var d : Vector2 = (c.global_position - player_ref.global_position)
		
		if d.length() < max_distance:
			var mark : Node2D
			if enemies_container.get_child_count() <= i:
				mark = enemy_mark_prefab.duplicate()
				enemies_container.add_child(mark)
				
			else:
				mark = enemies_container.get_child(i)
		
			mark.position = d.normalized() * ((d.length() / max_distance) * real_max_distance)
			mark.show()
