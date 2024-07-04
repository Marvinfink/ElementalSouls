extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_endboss_healthbar(health: int):
	self.show()
	$Timer.start()
	$TextureProgressBar.value = health


func hide_endboss_healthbar():
	self.hide()


func _on_timer_timeout():
	self.hide()
