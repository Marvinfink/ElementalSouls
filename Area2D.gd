extends Area2D


@onready var current_music_player = $AudioStreamPlayer2D

func _ready():
	for area in get_tree().get_nodes_in_group("music_areas"):
		area.connect("body_entered", self, "_on_Area2D_area_entered")
		area.connect("body_exited", self, "_on_Area2D_area_exited")

func _on_Area2D_area_entered(area):
	if current_music_player != null:
		current_music_player.stop()
	current_music_player = area.get_node("AudioStreamPlayer")
	current_music_player.play()

func _on_Area2D_area_exited(area):
	if current_music_player == area.get_node("AudioStreamPlayer"):
		current_music_player.stop()
		current_music_player = null
