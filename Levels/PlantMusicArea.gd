extends Area2D
@onready var plant_music = $PlantMusic
var volume = -15 

func _on_ready():
	plant_music.stop()
	
func _on_body_entered(body):
	if body.has_method("player"):
		monitoring = true
		AudioServer.set_bus_volume_db(0,volume)
		plant_music.play()
		get_node("../Ability_Added").show_plant_domain()

func _on_body_exited(body):
	if body.has_method("player"):
		plant_music.stop()


func _on_plant_music_finished():
	plant_music.play()
