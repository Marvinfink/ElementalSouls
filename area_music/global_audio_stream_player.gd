extends AudioStreamPlayer2D





# Dictionary to map music names to their respective audio streams
var music_dict: Dictionary = {
	"music1": load("res://music/Elemental_Souls_FireArea_Sound.wav"),
	
	# Add more music files as needed
}

func change_music(music_name: String) -> void:
	if music_name in music_dict:
		stream = music_dict[music_name]
		if playing:
			stop()
		play()
	else:
		print("Music name not found in dictionary")

func _on_MusicArea_entered(music_name: String) -> void:
	change_music(music_name)
