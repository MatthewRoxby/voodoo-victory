extends Panel

@export var bigSize : Vector2
@export var littleSize : Vector2

@onready var interface := $interface
@export var interface_littleScale := 0.285

@onready var player_ref := %player

@onready var cauldrons := $interface/cauldrons
@onready var spaceLabel := $"../Label"



var head := VoodooPart.PART_TYPE.RED
var larm := VoodooPart.PART_TYPE.RED
var rarm := VoodooPart.PART_TYPE.RED
var lleg := VoodooPart.PART_TYPE.RED
var rleg := VoodooPart.PART_TYPE.RED

func set_part_colour(part : String, col : VoodooPart.PART_TYPE):
	set(part, col)

func calculate_damage(enemy : Enemy) -> int:
	var matchingParts := 0
	matchingParts += int(enemy.head == head)
	matchingParts += int(enemy.rarm == rarm)
	matchingParts += int(enemy.larm == larm)
	matchingParts += int(enemy.legs == lleg)
	matchingParts += int(enemy.legs == rleg)
	
	return pow(2, matchingParts)

var expand := false

func _ready():
	interface.scale = Vector2.ONE * interface_littleScale
	size = littleSize
	mouse_filter = MOUSE_FILTER_STOP

func _process(delta):
	if Input.is_action_just_pressed("switch_to_voodoo"):
		expand = !expand
		mouse_filter = MOUSE_FILTER_PASS if expand else MOUSE_FILTER_STOP
		player_ref.can_move = !expand
		$interface/bubble.playing = expand
		
		for i in $interface/cauldrons.get_children():
			i.get_node("normal").restart()
			i.get_node("normal").emitting = expand
			
	
	size = lerp(size, bigSize if expand else littleSize, delta * 10.0)
	interface.scale = lerp(interface.scale, Vector2.ONE * (1.0 if expand else interface_littleScale), delta * 10.0)
	cauldrons.position.y = lerp(cauldrons.position.y, 0.0 if expand else 210.0, delta * 5.0)
	spaceLabel.position = lerp(spaceLabel.position, Vector2(298,705) if expand else Vector2(42,208), delta * 11.0)
