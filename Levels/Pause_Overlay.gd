extends CanvasLayer


@onready var back_button_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/BackSelected.png")
@onready var back_button_not_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/BackNotSelected.png")
@onready var menu_button_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/MenuSelected.png")
@onready var menu_button_not_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/MenuNotSelected.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_button_down():
	$Back_Button.icon = back_button_pressed


func _on_back_button_button_up():
	$Back_Button.icon = back_button_not_pressed


func _on_back_button_pressed():
	get_tree().paused = false
	self.hide()


func _on_menu_button_button_down():
	$Menu_Button.icon = menu_button_pressed


func _on_menu_button_button_up():
	$Menu_Button.icon = menu_button_not_pressed


func _on_menu_button_pressed():
	self.hide()
	get_node("../Main_Menu").show_main_menu()



func _input(event):
	if Input.is_action_just_pressed("esc"):
		if not get_node("../Main_Menu").visible and not get_node("../Game_Over_Overlay").visible and not self.visible:
			get_tree().paused = true
			self.show()
