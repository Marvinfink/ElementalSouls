extends Area2D
@onready var water_music = $Water_Music
var volume = -25

func _ready():
	water_music.stop()
	


func _on_body_entered(body):
	water_music.stop()
	monitoring = true 
	AudioServer.set_bus_volume_db(0,volume)
	water_music.play()
	
func _on_body_exited(body):
	water_music.stop()

func _on_water_music_finished():
	water_music.play()



