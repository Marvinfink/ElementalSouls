extends CharacterBody2D

var enemy = null
var speed:int=100;

var direction : Vector2 = Vector2.ZERO
var swing : bool = false
var walking : bool=false

var in_attack_range : bool = false
var enemy_attack_cooldown :bool = true
var health : int = 200
var player_alive : bool = true
var damage : int =200

@onready var animation_tree = $AnimationTree

#func _ready() -> void:
#	enemy = get_node("../Enemy")

func _physics_process(delta):
	if health <=0:
		player_alive=false
		health=0
		print("player is died")
		animation_tree["parameters/conditions/death"] = true
	if in_attack_range and Input.is_action_just_pressed("swing"):
		attack(damage)
	if not swing:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func _process(delta):
	direction = Input.get_vector("left","right","up","down")
	
	if direction != Vector2.ZERO and not swing:
		walking =true
		set_walking(walking)
		update_blend_position()
	else:
		walking=false
		set_walking(walking)
	
	if Input.is_action_just_pressed("swing") and walking:
		set_swing(true)
		animation_tree["parameters/conditions/walk"] = true

	elif Input.is_action_just_pressed("swing") and not walking:
		set_swing(true)
		animation_tree["parameters/conditions/idle"] = true

#play attack animation
func set_swing(value = false):
	swing = value
	animation_tree["parameters/conditions/swing"] = value
#play walking animation
func set_walking(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/idle"] = not value
#set animation directon
func update_blend_position():
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/walk/blend_position"] = direction

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
	
