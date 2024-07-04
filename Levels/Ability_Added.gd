extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


func show_new_ability():
	self.show()
	await get_tree().create_timer(4).timeout
	self.hide()
