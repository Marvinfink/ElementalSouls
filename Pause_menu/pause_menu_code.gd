extends Control
@onready var game_level = $"../../"

func _on_resume_pressed():
	game_level.pauseMenu()


func _on_quit_pressed():
	get_tree().quit()
