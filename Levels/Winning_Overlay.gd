extends CanvasLayer

var time_in_seconds: int

@onready var back_button_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/BackSelected.png")
@onready var back_button_not_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/BackNotSelected.png")
@onready var menu_button_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/MenuSelected.png")
@onready var menu_button_not_pressed := preload("res://Art/mystic_woods_free_2.1/overlay/MenuNotSelected.png")
@onready var victoryMusic = $victoryMusic

func _ready():
	
	$Winning_Overlay.hide()
	$Timer_Overlay.hide()
	time_in_seconds = 0


func start_timer():
	self.show()
	$game_timer.start()
	$Timer_Overlay.show()
	
	
func show_winning_screen():
	victoryMusic.play()
	get_tree().paused = true
	$Timer_Overlay.hide()
	$Winning_Overlay.show()
	$game_timer.stop()
	$Winning_Overlay/time_container.set_time_bar(time_in_seconds)


func update_timer():
	$Timer_Overlay/time_container.set_time_bar(time_in_seconds)

func _on_back_button_button_down():
	$Winning_Overlay/Back_Button.icon = back_button_pressed


func _on_back_button_button_up():
	$Winning_Overlay/Back_Button.icon = back_button_not_pressed


func _on_back_button_pressed():
	get_tree().paused = false
	self.hide()


func _on_menu_button_button_down():
	$Winning_Overlay/Menu_Button.icon = menu_button_pressed


func _on_menu_button_button_up():
	$Winning_Overlay/Menu_Button.icon = menu_button_not_pressed


func _on_menu_button_pressed():
	self.hide()
	get_node("../Main_Menu").show_main_menu()


func _on_game_timer_timeout():
	time_in_seconds += 1
	update_timer()
