extends CanvasLayer

@onready var menubutton = $MenuButton
@onready var selected_element: Elements.Element = -1
@onready var start_button_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/PlaySelected.png")
@onready var start_button_not_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/PlayNotSelected.png")
@onready var choose_button_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/ChooseSelected.png")
@onready var choose_button_not_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/ChooseNotSelected.png")
# sounds
@onready var fireClickSound = $fireClickSound
@onready var waterClickSound = $waterClickSound
@onready var lightningClickSound = $lightningClickSound
@onready var plantClickSound = $plantClickSound
@onready var menuMusic = $titelMusic
@onready var playButtonSound = $playButtonSound
# Called when the node enters the scene tree for the first time.
func _ready():
	menuMusic.play()
	get_tree().paused = true
	get_node("../Heart_bar").hide()
	get_node("../Mana_Bars").hide()
	selected_element = -1
	self.show()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func show_main_menu():
	get_tree().paused = true
	get_tree().reload_current_scene()
	selected_element = -1
	reset_button_position()
	get_node("../Heart_bar").hide()
	get_node("../Mana_Bars").hide()
	self.show()


func _on_button_pressed():
	if selected_element != -1:
		playButtonSound.play()
		menuMusic.stop()
		get_tree().paused = false
		self.hide()
		get_node("../Player1").set_first_element(selected_element)
		get_node("../Heart_bar").show()
		get_node("../Mana_Bars").show()
		get_node("../Winning_Overlay").start_timer()
		match selected_element:
			Elements.Element.ELECTRICITY:
				$"../firepoller".queue_free()
				$"../plantpoller".queue_free()
				$"../waterpoller".queue_free()
			Elements.Element.FIRE:
				$"../teslatower".queue_free()
				$"../plantpoller".queue_free()
				$"../waterpoller".queue_free()
			Elements.Element.PLANT:
				$"../teslatower".queue_free()
				$"../firepoller".queue_free()
				$"../waterpoller".queue_free()
			Elements.Element.WATER:
				$"../teslatower".queue_free()
				$"../firepoller".queue_free()
				$"../plantpoller".queue_free()

			
		return 
	$Error.text = "Bitte wähle ein Element!"


func _on_button_button_down():
	$Button.icon = start_button_pressed


func _on_button_button_up():
	$Button.icon = start_button_not_pressed

func reset_button_position():
	var position = 340
	$Error.text = ""
	$Water_Button.position.y = position
	$Fire_Button.position.y = position
	$Plant_Button.position.y = position
	$Electricity_Button.position.y = position
	
func _on_water_button_pressed():
	waterClickSound.play()
	reset_button_position()
	$Water_Button.position.y -= 30
	selected_element = Elements.Element.WATER


func _on_fire_button_pressed():
	fireClickSound.play()
	reset_button_position()
	$Fire_Button.position.y -= 30
	selected_element = Elements.Element.FIRE


func _on_plant_button_pressed():
	plantClickSound.play()
	reset_button_position()
	$Plant_Button.position.y -= 30
	selected_element = Elements.Element.PLANT


func _on_electricity_button_pressed():
	lightningClickSound.play()
	reset_button_position()
	$Electricity_Button.position.y -= 30
	selected_element = Elements.Element.ELECTRICITY

