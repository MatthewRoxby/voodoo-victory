extends Line2D

@export var length := 600

@export var amplitude := 10.0
@export var speed := 5.0
@export var sin_size := 30.0

func _ready():
	points.clear()
	var step = length / len(points)
	for i in range(len(points)):
		points[i] = Vector2(step * i, 0)

func _process(delta):
	var t : float = Time.get_ticks_msec() / 1000.0
	for i in range(len(points)):
		var s1 = sin((i * sin_size) + (t * speed))
		var s2 = sin((i * sin_size) + (t * speed)) + 0.5
		points[i].y = s1 * s2 * amplitude
