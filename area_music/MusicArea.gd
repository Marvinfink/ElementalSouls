extends Area2D

# The name of the music to be played when entering this area
@export var music_name: String

func _ready() -> void:
	self.connect("body_entered", _on_MusicArea_entered)

func _on_MusicArea_entered(body: Node) -> void:
	if body.name == "player_1":  # Replace with your player node name if different
		get_node("res://area_music/global_audio_stream_player.tscn")._on_MusicArea_entered(music_name)
