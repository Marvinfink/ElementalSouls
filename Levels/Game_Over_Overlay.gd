extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func game_over():
	get_tree().paused = true
	self.show()


func _on_button_main_menu_pressed():
	self.hide()
	get_node("../Main_Menu").show_main_menu()


func _on_button_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
