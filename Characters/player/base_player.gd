extends CharacterBody2D

"""
preload:
	- variables
	- textures
	- nodes
"""

#playerstats
var health : int = 200
var speed:int=100;
var damage : int =200
var element =Elements.Element
var player_alive : bool = true

# set in base
var in_attack_range : bool = false
var enemy_attack_cooldown :bool = true
var special_attack_cooldown :bool = true
var player_position
var enemy = null
var player_node 
var special_attack_bar : int = 0

#player movement and animation
var direction : Vector2 = Vector2.ZERO
var mouse_position : Vector2 = Vector2.ZERO
var player_direction : Vector2 = Vector2.ZERO
var swing : bool = false
var walking : bool=false

#Dash variables
var is_dashing : bool = false
var dash_speed : float = 200
var dash_duration : float = 0.2  # Dash duration in seconds
var dash_timer : float = 0
var dash_direction : Vector2 = Vector2.ZERO
var dash_used :bool = true


@onready var animation_tree1 = $animation_tree
var element_textures = {
	Elements.Element.FIRE: preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_fire.png"),
	Elements.Element.WATER: preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_water.png"),
	Elements.Element.ELETRICITY: preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_electro.png"),
	Elements.Element.PLANT: preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_plant.png")
}


func _ready():
	element=Elements.Element.FIRE
	$Sprite2D.texture=element_textures[element]
	player_node=get_node(".")


#take damage from enemy
func enemy_attack(damage):
	health = health-damage
	if health <=0:
		player_alive=false
		health=0
		print("player is died")
		animation_tree1["parameters/conditions/death"]=true
	print(health)

func player():
	pass

# check for enemy if in range
func _on_player_hitbox_body_entered(body):
	enemy=body
	if body.has_method("enemy"):
		in_attack_range=true
# check for enemy if out of range
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		in_attack_range=false
# attack cooldown			
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
# special attack cooldown	
func _on_special_attack_cooldown_timeout():
	special_attack_cooldown = true
# dash cooldown
func _on_dash_timer_timeout():
	dash_used=true # Replace with function body.
