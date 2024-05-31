extends CharacterBody2D
#base enemy

var health: int
var speed: int
var damage: float
var element: int
var cooldown: float
var attack_speed: float
var player_in_range: bool
var player_chase: bool
var enemy_attack_cooldown: bool
var player: Node
var dead: bool
var element_multipliers

@onready var animation_tree = $AnimationTree

func _ready():
	set_data()
	player_in_range = false
	player_chase = false
	enemy_attack_cooldown = true
	player = get_node("../Player1")
	dead = false
	$attack_cooldown.wait_time = cooldown
	element_multipliers = preload("res://Characters/elements.gd").new()

func attack():
	if player_in_range and enemy_attack_cooldown:
		print("attack player")
		enemy_attack_cooldown = false
		#animation_tree["parameters/conditions/attack"] = true
		#await attack_move()
		await get_tree().create_timer(attack_speed).timeout
		#animation_tree["parameters/conditions/attack"] = false
		if (player_in_range):
			player.enemy_attack(damage)
		$attack_cooldown.start()

func move_position():
	if player_chase and !dead:
		var direction = (player.position - position).normalized()
		var velocity = direction * speed * get_physics_process_delta_time()
		move_and_collide(velocity)

func player_attack(amount):
	print("damage")
	health -= amount
	if health <= 0:
		dead = true
		set_process(false)
		animation_tree["parameters/conditions/death"] = true
		await get_tree().create_timer(2.0).timeout
		queue_free()

func attack_move():
	pass

func set_data():
	pass
	
func enemy():
	pass

func _on_detection_area_body_entered(body):
	player_chase = true
	animation_tree["parameters/conditions/is_walking"] = true
	animation_tree["parameters/conditions/idle"] = false

func _on_detection_area_body_exited(body):
	player_chase = false
	animation_tree["parameters/conditions/is_walking"] = false
	animation_tree["parameters/conditions/idle"] = true

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false
