extends Area2D
@onready var lightning_music = $LightningMusic
var volume = -15



func _on_ready():
	lightning_music.stop()


func _on_body_entered(body):
	if body.has_method("player"):
		monitoring = true
		AudioServer.set_bus_volume_db(0,volume)
		lightning_music.play()
		get_node("../Ability_Added").show_electricity_domain()



func _on_body_exited(body):
	if body.has_method("player"):
		lightning_music.stop()


func _on_lightning_music_finished():
	lightning_music.play()
