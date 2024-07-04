extends CanvasLayer

@onready var new_ability := preload("res://Art/mystic_woods_free_2.1/overlay/NewSpecialAvailable.png")
@onready var plant_domain := preload("res://Art/mystic_woods_free_2.1/overlay/ForestOfLife.png")
@onready var water_domain := preload("res://Art/mystic_woods_free_2.1/overlay/Oceans_Embrace.png")
@onready var fire_domain := preload("res://Art/mystic_woods_free_2.1/overlay/LavaDomain.png")
@onready var electricity_domain := preload("res://Art/mystic_woods_free_2.1/overlay/ThunderPlains.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


func show_new_ability():
	$TextureRect.texture = new_ability
	self.show()
	await get_tree().create_timer(4).timeout
	self.hide()


func show_fire_domain():
	$TextureRect.texture = fire_domain
	self.show()
	await get_tree().create_timer(4).timeout
	self.hide()
	
	
func show_water_domain():
	$TextureRect.texture = water_domain
	self.show()
	await get_tree().create_timer(4).timeout
	self.hide()
	
	
func show_plant_domain():
	$TextureRect.texture = plant_domain
	self.show()
	await get_tree().create_timer(4).timeout
	self.hide()
	
	
func show_electricity_domain():
	$TextureRect.texture = electricity_domain
	self.show()
	await get_tree().create_timer(4).timeout
	self.hide()
