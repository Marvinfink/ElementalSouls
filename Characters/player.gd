extends CharacterBody2D


#player movement and animation
var direction : Vector2 = Vector2.ZERO
var mouse_position : Vector2 = Vector2.ZERO
var player_direction : Vector2 = Vector2.ZERO
var swing : bool = false
var walking : bool=false

#player attack
var enemy = null
var in_attack_range : bool = false
var enemy_attack_cooldown :bool = true
var player_position
var player_node 
#playerstats
var speed:int=100;
var health : int = 200
var player_alive : bool = true
var damage : int =200
var old_element : String
var element : String = "fire" #1=fire, 2=water, 3=electro, 4=plant


#@onready var animation_tree = $AnimationTree
@onready var animation_tree1 = $animation_tree
var element_textures = {
	"fire": preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_fire.png"),
	"water": preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_water.png"),
	"electro": preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_electro.png"),
	"plant": preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_plant.png")
}

func _ready():
	$Sprite2D.texture=element_textures[element]
	player_node=get_node(".")

func _physics_process(delta):
	if health <=0:
		player_alive=false
		health=0
		print("player is died")
		animation_tree1["parameters/conditions/death"]=true
	if in_attack_range and Input.is_action_just_pressed("swing"):
		attack(damage)
	if not swing:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func _process(delta):
	player_position=player_node.position
	mouse_position= get_global_mouse_position()

	player_direction=mouse_position-player_position
	player_direction=player_direction.normalized()
	
	direction = Input.get_vector("left","right","up","down")
	update_blend_position()
	
	if direction != Vector2.ZERO and not swing:
		walking =true
		set_walking(walking)
		update_blend_position()
	else:
		walking=false
		set_walking(walking)
	
	#change element
	if Input.is_action_just_pressed("fire"):
		change_element("fire")
	elif Input.is_action_just_pressed("water"):
		change_element("water")
	elif Input.is_action_just_pressed("electro"):
		change_element("electro")
	elif Input.is_action_just_pressed("plant"):
		change_element("plant")

		
	if Input.is_action_just_pressed("swing") and walking:
		set_swing(true)
		animation_tree1["parameters/conditions/walk"] = true
	elif Input.is_action_just_pressed("swing") and not walking:
		set_swing(true)
		animation_tree1["parameters/conditions/idle"] = true
		
	
#play attack animation
#Todo: change animations to swingfire,swingwater,...
#change through animationtrees?
func set_swing(value = false):
	swing = value
	animation_tree1["parameters/conditions/swing"]=value
						
#play walking animation
func set_walking(value,element="fire"):
	animation_tree1["parameters/conditions/walk"]=value
	animation_tree1["parameters/conditions/idle"]=not value
	
#set animation directon
func update_blend_position():
	animation_tree1["parameters/attack/blend_position"] = player_direction
	animation_tree1["parameters/walk/blend_position"] = player_direction
	animation_tree1["parameters/idle/blend_position"] = player_direction

func player():
	pass

#take damage from enemy
func enemy_attack(damage):
		health = health-damage
		print(health)
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		
func attack(damage):
	enemy.player_attack(damage)		

# Change element and sprite texture
func change_element(new_element):
	element = new_element
	$Sprite2D.texture = element_textures[element]

#check for enemy if in range
func _on_player_hitbox_body_entered(body):
	enemy=body
	if body.has_method("enemy"):
		in_attack_range=true
#check for enemy if out of range
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		in_attack_range=false
			
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
