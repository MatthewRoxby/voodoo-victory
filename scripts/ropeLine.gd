extends Line2D


@export var ropeLength := 30.0
@export var constrain := 1.0 # distance between points
@export var gravity := Vector2(0,9.8)
@export var dampening := 0.9

var pos: Array[Vector2]
var posPrev: Array[Vector2]
var pointCount: int

@export var end_pin : Node2D

func _ready()->void:
	pointCount = get_pointCount(ropeLength)
	resize_arrays()
	init_position()

func get_pointCount(distance: float)->int:
	return int(ceil(distance / constrain))

func resize_arrays():
	pos.resize(pointCount)
	posPrev.resize(pointCount)

func init_position()->void:
	for i in range(pointCount):
		pos[i] = position + Vector2(constrain *i, 0)
		posPrev[i] = position + Vector2(constrain *i, 0)

func _process(delta)->void:
	update_points(delta)
	update_constrain()
	
	#update_constrain()	#Repeat to get tighter rope
	#update_constrain()
	
	# Send positions to Line2D for drawing
	points = pos

func set_start(p:Vector2)->void:
	pos[0] = p
	posPrev[0] = p

func set_last(p:Vector2)->void:
	pos[pointCount-1] = p
	posPrev[pointCount-1] = p

func update_points(delta)->void:
	for i in range (pointCount):
		# not first and last || first if not pinned || last if not pinned
		if i!=0 && i != pointCount - 1:
			var velocity = (pos[i] -posPrev[i]) * dampening
			posPrev[i] = pos[i]
			pos[i] += velocity + (gravity * delta)

func update_constrain()->void:
	for i in range(pointCount):
		if i == pointCount-1:
			pos[i] = to_local(end_pin.global_position)
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		
		# if first point
		if i == 0:
			pos[i] = Vector2.ZERO
		# if last point, skip because no more points after it
		elif i == pointCount-1:
			
			pass
		# all the rest
		else:
			pos[i] -= vec2 * (percent/2)
			if i + 1 != pointCount - 1:
				pos[i+1] += vec2 * (percent/2)
