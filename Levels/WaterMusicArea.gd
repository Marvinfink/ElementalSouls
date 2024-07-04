extends Area2D

@onready var water_music = $WaterMusic
var volume = -25 

func _on_ready():
	water_music.stop()



func _on_body_entered(body):
	if body.has_method("player"):
		monitoring=true
		AudioServer.set_bus_volume_db(0,volume)
		water_music.play()
		get_node("../Ability_Added").show_water_domain()


func _on_body_exited(body):
	if body.has_method("player"):
		water_music.stop()
