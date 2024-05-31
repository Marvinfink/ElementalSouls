extends TextureButton



@onready var panel = $Panel
@onready var label = $MarginContainer/Label

var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/3"



func _on_pressed():
	level = min( level+1, 3)
	panel.show_behind_parent = true
	

