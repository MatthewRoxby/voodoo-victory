#MusicController.gd
extends Node

#the player used for music
var player : AudioStreamPlayer

#volume field allows for each song to have a customisable volume to make sure it isn't too quiet or too loud
var vol := 0.0

#the current stream being played. Initially set to null
var current_stream : AudioStream = null

func _ready():
	#ensure the music still plays when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	#create a new AudioStreamPlayer
	player = AudioStreamPlayer.new()
	#set the bus
	player.bus = "Music"
	#set the volume
	player.volume_db = linear_to_db(vol)
	#add as a child of the Autoload
	add_child(player)

#function used for tweening volume
func vol_callback(v : float):
	player.volume_db = linear_to_db(v)

#function used to change the current song
func change_song(new_stream : AudioStream, new_vol : float):
	
	#if a song is currently playing, fade out
	if current_stream != null:
		var t1 := create_tween()
		t1.tween_method(vol_callback, vol, 0.0, 1.0)
		await t1.finished
	
	#set the new stream
	current_stream = new_stream
	player.stream = current_stream
	#set the correct volume
	vol = new_vol
	player.play()
	#fade back in
	var t2 := create_tween()
	t2.tween_method(vol_callback, 0.0, vol, 1.0)
