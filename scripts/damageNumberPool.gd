extends Node2D

@onready var prefab : Node2D = $prefabs/damageNum

@onready var container : Node2D = $instances

var dead : Array[Node2D]

func _ready():
	prefab.hide()

func free_instance(instance : Node2D):
	container.remove_child(instance)
	dead.append(instance)
	print("pool size: " , len(dead))

func add_damage_number(pos : Vector2, number : int):
	if len(dead) == 0:
		#make new instance
		var instance : Node2D = prefab.duplicate()
		instance.set("pool", self)
		instance.position = pos
		container.add_child(instance)
		instance.anim(str(number))
	else:
		#use existing instance
		var instance : Node2D = dead.pop_back()
		instance.position = pos
		container.add_child(instance)
		instance.anim(str(number))
	
	print("pool size: " , len(dead))
