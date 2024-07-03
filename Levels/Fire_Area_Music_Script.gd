extends Area2D

@onready var fire_music = $Fire_Music
var volume = -25

func _ready():
	fire_music.stop()


func _on_fire_music_finished():
	fire_music.play()
	
	
func _on_body_entered(body):
	fire_music.stop()
	monitoring = true
	AudioServer.set_bus_volume_db(0,volume)
	fire_music.play()

	


func _on_body_exited(body):
	fire_music.stop()



