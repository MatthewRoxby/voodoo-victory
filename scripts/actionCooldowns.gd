extends Control

@onready var player_ref := %player

@onready var needle_ref := player_ref.get_node("needle")

@onready var swing_sprite := $swing/Sprite2D

@onready var roll_sprite := $roll/Sprite2D

func _process(delta):
	swing_sprite.frame = lerp(8, 0, max(needle_ref.get("cooldown"), 0.0) / needle_ref.get("max_cooldown"))
	roll_sprite.frame = lerp(7, 0, max(player_ref.get("roll_cooldown"), 0.0) / player_ref.get("roll_max_cooldown"))
