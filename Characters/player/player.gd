extends CharacterBody2D


#playerstats
var health : int = 50
var speed:int=100;
var damage : int =50
var special_damage : int = 100
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

#special attack
var projectile_direction
var special_in_range : bool = false

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
	Elements.Element.FIRE: preload("res://Art/mystic_woods_free_2.1/sprites/characters/Fire/Sprite_Fire_Complete_Outlines-Sheet.png"),
	Elements.Element.WATER: preload("res://Art/mystic_woods_free_2.1/sprites/characters/Water/Sprite_Water_Complete-Sheet.png"),
	Elements.Element.ELETRICITY: preload("res://Art/mystic_woods_free_2.1/sprites/characters/Electro/Sprite_Electro_Complete-Sheet.png"),
	Elements.Element.PLANT: preload("res://Art/mystic_woods_free_2.1/sprites/characters/Plant/Sprite_Plant_Complete_Outlines-Sheet.png")
}

const marksman_projectile := preload("res://Characters/projectile/player_projectile.tscn")

func _ready():
	element=Elements.Element.FIRE
	Elements.set_current_element(element)
	print(element)
	$Sprite2D2.texture=element_textures[element]
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
	if Input.is_action_just_pressed("special_attack") and special_attack_bar >= 0:
		handle_special_attack()
	#change element
	if Input.is_action_just_pressed("fire"):
		element=Elements.Element.FIRE
		change_element()
	elif Input.is_action_just_pressed("water"):
		element=Elements.Element.WATER
		change_element()
	elif Input.is_action_just_pressed("electro"):
		element=Elements.Element.ELECTRICITY
		change_element()
	elif Input.is_action_just_pressed("plant"):
		element=Elements.Element.PLANT
		change_element()

	#swing while walking
	if Input.is_action_just_pressed("swing"):# and walking:
		set_swing(true)

		
	
func _physics_process(delta):
	if animation_tree1.get("parameters/conditions/dash"):
		return

	#walking
	direction = Input.get_vector("left","right","up","down")
	if not swing:
		player_looking()
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
		
	handle_dash(delta)
	move_and_slide()
	
	
# attack functions
func attack(damage):
	special_attack_bar +=1
	if enemy_attack_cooldown:
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		enemy.player_attack(damage,Elements.get_current_element())	
		
func special_attack(special_damage):
	enemy.player_attack(special_damage,Elements.get_current_element())
	
func special_attack_range():
	var projectile := marksman_projectile.instantiate()
	owner.add_child(projectile)
	projectile_direction = (get_global_mouse_position() - global_position).normalized()
	projectile.position=global_position
	projectile.rotation = self.global_position.direction_to(get_global_mouse_position()).angle()
	special_attack_bar = 0
	
func special_attack_close():
	if special_in_range:
		special_attack(special_damage)

func handle_special_attack():
	if element == 0:
		print("Fire special")
		special_attack_close()
	elif element == 1:
		print("water special")
		special_attack_range()
		#start animation
	elif element == 2:
		print("plant special")
		special_attack_range()
		#start animation
	else:
		print("elctro special")
		special_attack_close()
		#start animation

# Change element and sprite texture
func change_element():
	Elements.set_current_element(element)
	$Sprite2D2.texture = element_textures[element]

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
	#$swing_duration.start()
	animation_tree1["parameters/conditions/swing"]=value
	set_physics_process(false)
	await get_tree().create_timer(0.35).timeout
	set_physics_process(true)

# walking animation
func set_walking(value):
	animation_tree1["parameters/conditions/walk"]=value
	animation_tree1["parameters/conditions/idle"]=not value

#dash animation
func set_dash(value = false):
	animation_tree1["parameters/conditions/dash"]=value

#damage animation
func set_damage(value = false):
	animation_tree1["parameters/conditions/damage"]=value
	set_physics_process(false)
	await get_tree().create_timer(0.35).timeout
	set_physics_process(true)
# set animation direction
func update_blend_position():
	animation_tree1["parameters/attack/blend_position"] = player_direction
	animation_tree1["parameters/walk/blend_position"] = player_direction
	animation_tree1["parameters/idle/blend_position"] = player_direction
	animation_tree1["parameters/dash/blend_position"] = player_direction
	animation_tree1["parameters/damage/blend_position"] = player_direction


#take damage from enemy
func enemy_attack(damage):
	health = health-damage
	set_damage(true)
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
#check for enemy in special attack range
func _on_special_attack_body_entered(body):
	enemy=body
	if body.has_method("enemy"):
		special_in_range = true
#check for enemy out of special attack range
func _on_special_attack_body_exited(body):
	if body.has_method("enemy"):
		special_in_range = false
# attack cooldown			
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
# special attack cooldown	
func _on_dash_timer_timeout():
	dash_used = true

