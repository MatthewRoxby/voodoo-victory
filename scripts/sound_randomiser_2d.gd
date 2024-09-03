extends AudioStreamPlayer2D

@export var pitch_min := 0.8
@export var pitch_max := 1.2

func play_random():
	pitch_scale = randf_range(pitch_min, pitch_max)
	play()
