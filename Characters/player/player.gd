extends CharacterBody2D


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

#@onready var animation_tree = $AnimationTree
@onready var animation_tree1 = $animation_tree
var element_textures = {
	#Elements.Element.FIRE: preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_fire.png"),
	#Elements.Element.WATER: preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_water.png"),
	#Elements.Element.ELETRICITY: preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_electro.png"),
	#Elements.Element.PLANT: preload("res://Art/mystic_woods_free_2.1/sprites/Foozle_2DC0009_Lucifer_Warrior_Pixel_Art/sprite_plant.png")
}

func _ready():
	element=Elements.Element.FIRE
	#$Sprite2D.texture=element_textures[element]
	player_node=get_node(".")
	
#Handles the user input
func _input(event):
	# handle dash input
	if Input.is_action_just_pressed("dash") && dash_used:
		dash()
	# handle swing input
	if in_attack_range and Input.is_action_just_pressed("swing") and enemy_attack_cooldown == true:
		attack(damage)
	# handle special attack input
	if Input.is_action_just_pressed("special_attack") and special_attack_bar >= 5:
		special_attack()
	#change element
	if Input.is_action_just_pressed("fire"):
		element=Elements.Element.FIRE
		change_element()
	elif Input.is_action_just_pressed("water"):
		element=Elements.Element.WATER
		change_element()
	elif Input.is_action_just_pressed("electro"):
		element=Elements.Element.ELETRICITY
		change_element()
	elif Input.is_action_just_pressed("plant"):
		element=Elements.Element.PLANT
		change_element()

	#swing while walking
	if Input.is_action_just_pressed("swing") and walking:
		set_swing(true)
		animation_tree1["parameters/conditions/walk"] = true
	#swing while standing
	elif Input.is_action_just_pressed("swing") and not walking:
		set_swing(true)
		#await? get animationtree out of player.gd
		animation_tree1["parameters/conditions/idle"] = true
		
func _physics_process(delta):
	#walking
	direction = Input.get_vector("left","right","up","down")
	if not swing:
		velocity = direction * speed
		update_blend_position()
	else:
		velocity = Vector2.ZERO
	
	if direction != Vector2.ZERO and not swing:
		walking =true
		set_walking(walking)
		update_blend_position()
	else:
		walking=false
		set_walking(walking)
	move_and_slide()
	player_looking()
	handle_dash(delta)
	

# attack functions
func attack(damage):
	special_attack_bar +=1
	if enemy_attack_cooldown:
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		enemy.player_attack(damage,element)	

func special_attack():
	special_attack_bar = 0
	print("SPECIAL ATTACK")
	print(element)


# Change element and sprite texture
func change_element():
	$Sprite2D.texture = element_textures[element]

# Changes player direction to mouse position
func player_looking():	
	player_position=player_node.position
	mouse_position= get_global_mouse_position()

	player_direction=mouse_position-player_position
	player_direction=player_direction.normalized()
	$player_hitbox/CollisionPolygon2D.look_at(get_global_mouse_position())
	
	
# dash functions
func dash():
	dash_used=false
	mouse_position=get_global_mouse_position()
	dash_direction = (mouse_position - global_position).normalized()
	is_dashing=true
	dash_timer=0
	$dash_timer.start()

func handle_dash(delta):
	if is_dashing:
		dash_timer+=delta
		if dash_timer>=dash_duration:
			is_dashing=false
			dash_timer=0
			velocity=Vector2.ZERO
			
		else:
			velocity = dash_direction * dash_speed
		move_and_slide()


# swing animation
func set_swing(value = false):
	swing = value
	animation_tree1["parameters/conditions/swing"]=value

# walking animation
func set_walking(value):
	animation_tree1["parameters/conditions/walk"]=value
	animation_tree1["parameters/conditions/idle"]=not value

# set animation direction
func update_blend_position():
	animation_tree1["parameters/attack/blend_position"] = player_direction
	animation_tree1["parameters/walk/blend_position"] = player_direction
	animation_tree1["parameters/idle/blend_position"] = player_direction



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
