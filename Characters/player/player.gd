extends CharacterBody2D

#playerstats
var health: int = 10
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
var walking : bool = false

#special attack
var projectile_direction
var special_in_range : bool = false
var spells_available = []

#Dash variables
var is_dashing : bool = false
var dash_speed : float = 200
var dash_duration : float = 0.2  # Dash duration in seconds
var dash_timer : float = 0
var dash_direction : Vector2 = Vector2.ZERO
var dash_used :bool = false

#overlay
@onready var mana_handler: Control = get_node("../Mana_Bars/Control")
@onready var health_bar = get_node("../Heart_bar/heart_container")

#sounds
@onready var walkingSound = $WalkingSound
@onready var dashSound = $DashSound
@onready var deathSound = $dearhSound
@onready var swingSoundCharacter = $swingSoundCharacter

#@onready var animation_tree = $AnimationTree
@onready var animation_tree1 = $animation_tree
var element_textures = {
	Elements.Element.FIRE: preload("res://Art/mystic_woods_free_2.1/sprites/characters/Fire/Sprite_Fire_Complete_Outlines-Sheet.png"),
	Elements.Element.WATER: preload("res://Art/mystic_woods_free_2.1/sprites/characters/Water/Sprite_Water_Complete-Sheet.png"),
	Elements.Element.ELECTRICITY: preload("res://Art/mystic_woods_free_2.1/sprites/characters/Electro/Sprite_Electro_Complete-Sheet.png"),
	Elements.Element.PLANT: preload("res://Art/mystic_woods_free_2.1/sprites/characters/Plant/Sprite_Plant_Complete_Outlines-Sheet.png")
}

@onready var electricity_projectile := preload("res://enemy/projectile/bolt.tscn")
@onready var water_projectile := preload("res://enemy/projectile/wave.tscn")
@onready var fire_projectile := preload("res://enemy/projectile/fire_tornado.tscn")
@onready var plant_projectile := preload("res://enemy/projectile/thorns.tscn")

func _ready():
	player_node=get_node(".")
	health_bar.set_max_hearts(health)


#Handles the user input
func _input(event):
	# handle dash input
	if Input.is_action_just_pressed("dash") and mana_handler.use_dash():
		dash_used=true
		dash()
		dashSound.play()
	# handle swing input
	if in_attack_range and Input.is_action_just_pressed("swing") and enemy_attack_cooldown == true:
		attack(damage)
	# handle special attack input
	if Input.is_action_just_pressed("special_attack"):
		handle_special_attack()
	#swing while walking
	if Input.is_action_just_pressed("swing"):# and walking:
		set_swing(true)
		swingSoundCharacter.play()
	#change element
	if Input.is_action_just_pressed("fire"):
		element=Elements.Element.FIRE
	elif Input.is_action_just_pressed("water"):
		element=Elements.Element.WATER
	elif Input.is_action_just_pressed("electro"):
		element=Elements.Element.ELECTRICITY
	elif Input.is_action_just_pressed("plant"):
		element=Elements.Element.PLANT
	$Sprite2D2.texture = element_textures[element]


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
		if not walking:
			walkingSound.play()
		walking =true
		set_walking(walking)
		update_blend_position()	
	else:
		if walking:
			#walkingSound.volume_db(0,15)
			walkingSound.stop()
		walking=false
		set_walking(walking)
	if dash_used:
		handle_dash(delta)
	move_and_slide()


# attack functions
func attack(damage):
	mana_handler.load_spell()
	if enemy_attack_cooldown and enemy.has_method("enemy"):
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		enemy.player_attack(damage,element)	


func handle_special_attack():
	match element:
		Elements.Element.FIRE:
			if spells_available[Elements.Element.FIRE] and mana_handler.use_spell():
				use_fire_spell()
				set_spell(true)
		Elements.Element.WATER:
			if spells_available[Elements.Element.WATER] and mana_handler.use_spell():
				use_water_spell()
				set_spell(true)
		Elements.Element.ELECTRICITY:
			if spells_available[Elements.Element.ELECTRICITY] and mana_handler.use_spell():
				use_electricity_spell()
				set_spell(true)
		Elements.Element.PLANT:
			if spells_available[Elements.Element.PLANT] and mana_handler.use_spell():
				use_plant_spell()
				set_spell(true)


func use_fire_spell():
	var projectile := fire_projectile.instantiate()
	projectile.global_position = self.global_position
	projectile.set_direction(get_global_mouse_position() - global_position)
	projectile.created_by_player = true
	projectile.damage = damage
	projectile.range = 150
	owner.add_child(projectile)


func use_water_spell():
	var projectile := water_projectile.instantiate()
	var angle = global_position.direction_to(get_global_mouse_position()).angle()
	if abs(angle) >= PI/2 :
		projectile.scale.y = -1
	projectile.global_position = self.global_position
	projectile.set_direction(get_global_mouse_position() - global_position)
	projectile.rotation = angle
	projectile.created_by_player = true
	projectile.damage = damage
	owner.add_child(projectile)


func use_plant_spell():
	var projectile := plant_projectile.instantiate()
	projectile.created_by_player = true
	projectile.global_position = get_global_mouse_position()
	projectile.damage = damage
	owner.add_child(projectile)


func use_electricity_spell():
	var angle = global_position.direction_to(get_global_mouse_position()).angle()
	var projectile := electricity_projectile.instantiate()
	var position = self.global_position
	var half_width = 60
	var offset = Vector2(half_width, 0).rotated(angle)
	projectile.rotation = angle
	projectile.global_position = position + offset
	projectile.created_by_player = true
	projectile.damage = damage
	owner.add_child(projectile)


# Changes player direction to mouse position
func player_looking():	
	player_position=player_node.position
	mouse_position= get_global_mouse_position()
	player_direction=mouse_position-player_position
	player_direction=player_direction.normalized()
	$player_hitbox/CollisionPolygon2D.look_at(get_global_mouse_position())


# dash functions
func dash():
	mouse_position=get_global_mouse_position()
	dash_direction = (mouse_position - global_position).normalized()
	set_dash(true)


func handle_dash(delta):
	dash_timer+=delta
	if dash_timer>=dash_duration:
		dash_used=false
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


func set_spell(value = false):
	animation_tree1["parameters/conditions/spell"]=value

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
	animation_tree1["parameters/spell/blend_position"] = player_direction


#take damage from enemy
func enemy_attack():
	health -= 1
	health_bar.set_heart_bar(health)
	set_damage(true)
	if health <=0:
		deathSound.play()
		player_alive=false
		health=0
		print("player is died")
		animation_tree1["parameters/conditions/death"]=true
		await get_tree().create_timer(3.0).timeout
		get_node("../Game_Over_Overlay").game_over()
	print(health)


func set_first_element(e: Elements.Element):
	element = e
	spells_available.resize(Elements.Element.size())
	$Sprite2D2.texture=element_textures[element]
	for elem in Elements.Element.values():
		spells_available[elem] = false
	spells_available[e] = true


func endboss_killed(el: Elements.Element):
	spells_available[el] = true
	var check = false
	for elem in Elements.Element.values():
		if not spells_available[elem]:
			get_node("../Ability_Added").show_new_ability()
			health = 10
			health_bar.set_heart_bar(health)
			return
	get_node("../Winning_Overlay").show_winning_screen()


func player():
	pass


# check for enemy if in range
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy=body
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
