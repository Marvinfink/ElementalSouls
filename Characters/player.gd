extends CharacterBody2D

# player movement and animation
var direction : Vector2 = Vector2.ZERO
var mouse_position : Vector2 = Vector2.ZERO
var player_direction : Vector2 = Vector2.ZERO
var swing : bool = false
var walking : bool = false

# player attack
var enemy = null
var in_attack_range : bool = false
var enemy_attack_cooldown : bool = true

# player stats
var speed: int = 100
var health : int = 200
var player_alive : bool = true
var damage : int = 200
var element : String = "fire" # "fire", "water", "electro", "plant"

@onready var animation_tree_fire = $AnimationTreeFire
@onready var animation_tree_water = $AnimationTreeWater
@onready var animation_tree_electro = $AnimationTreeElectro
@onready var animation_tree_plant = $AnimationTreePlant

var current_animation_tree = null

func _ready():
	current_animation_tree = animation_tree_fire

func _physics_process(delta):
	if health <= 0:
		player_alive = false
		health = 0
		print("player has died")
		current_animation_tree["parameters/conditions/death"] = true
	if in_attack_range and Input.is_action_just_pressed("swing"):
		attack(damage)
	if not swing:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _process(delta):
	mouse_position = get_viewport().get_mouse_position() - global_position
	player_direction = mouse_position.normalized()
	direction = Input.get_vector("left", "right", "up", "down")
	update_blend_position()

	if direction != Vector2.ZERO and not swing:
		walking = true
		set_walking(walking)
	else:
		walking = false
		set_walking(walking)

	# change element
	if Input.is_action_just_pressed("fire"):
		element = "fire"
		switch_animation_tree(animation_tree_fire)
	elif Input.is_action_just_pressed("water"):
		element = "water"
		switch_animation_tree(animation_tree_water)
	elif Input.is_action_just_pressed("electro"):
		element = "electro"
		switch_animation_tree(animation_tree_electro)
	elif Input.is_action_just_pressed("plant"):
		element = "plant"
		switch_animation_tree(animation_tree_plant)

	# start swing animation
	if Input.is_action_just_pressed("swing") and walking:
		set_swing(true)
		current_animation_tree["parameters/conditions/walk"] = true
	elif Input.is_action_just_pressed("swing") and not walking:
		set_swing(true)
		current_animation_tree["parameters/conditions/idle"] = true

# switch between animation trees
func switch_animation_tree(new_tree):
	if current_animation_tree != null:
		current_animation_tree.active = false
	current_animation_tree = new_tree
	current_animation_tree.active = true

# play attack animation
func set_swing(value = false):
	swing = value
	current_animation_tree["parameters/conditions/swing"] = value

# play walking animation
func set_walking(value):
	current_animation_tree["parameters/conditions/is_walking"] = value
	current_animation_tree["parameters/conditions/idle"] = not value

# set animation direction
func update_blend_position():
	current_animation_tree["parameters/attack/blend_position"] = player_direction
	current_animation_tree["parameters/walk/blend_position"] = player_direction
	current_animation_tree["parameters/idle/blend_position"] = player_direction

# handle enemy attack
func enemy_attack(damage):
	health -= damage
	print(health)
	enemy_attack_cooldown = false
	$attack_cooldown.start()

# attack enemy
func attack(damage):
	if enemy:
		enemy.player_attack(damage)

# check for enemy in range
func _on_player_hitbox_body_entered(body):
	enemy = body
	if body.has_method("enemy"):
		in_attack_range = true

# check for enemy out of range
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		in_attack_range = false

# reset attack cooldown
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
