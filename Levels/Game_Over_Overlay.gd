extends CanvasLayer


@onready var back_button_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/BackSelected.png")
@onready var back_button_not_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/BackNotSelected.png")
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


func _on_button_main_menu_button_down():
	$Button_Main_Menu.icon = back_button_pressed


func _on_button_main_menu_button_up():
	$Button_Main_Menu.icon = back_button_not_pressed
