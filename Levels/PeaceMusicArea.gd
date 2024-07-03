extends Area2D
@onready var peace_music = $PeaceMusic
var volume = -25


func _on_ready():
	peace_music.stop()


func _on_peace_music_finished():
	peace_music.play()


func _on_body_entered(body):
	if body.has_method("player"):
		monitoring = true
		AudioServer.set_bus_volume_db(0,volume)
		peace_music.play()



func _on_body_exited(body):
	if body.has_method("player"):
		peace_music.stop()
