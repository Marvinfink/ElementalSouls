extends Area2D

@onready var fire_music = $FireMusic
var volume = -15 

func _on_ready():
	fire_music.stop()



func _on_body_entered(body):
	if body.has_method("player"):
		monitoring = true
		AudioServer.set_bus_volume_db(0, volume)
		fire_music.play()
		get_node("../Ability_Added").show_fire_domain()
		


func _on_body_exited(body):
	if body.has_method("player"):
		fire_music.stop()
