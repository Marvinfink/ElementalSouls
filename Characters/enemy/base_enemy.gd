extends CharacterBody2D
#base enemy

# variable for each enemy
@export var health: int
@export var speed: int
@export var damage: float
@export var element: Elements.Element
@export var cooldown: float
# set in base
var player_in_range: bool
var player_chase: bool
var enemy_attack_cooldown: bool
var player: Node
var dead: bool

@onready var animation_tree = $AnimationTree


func _ready():
	set_data()
	player_in_range = false
	player_chase = false
	enemy_attack_cooldown = true
	player = get_node("../Player1")
	dead = false
	$attack_cooldown.wait_time = cooldown


func move_position(delta: float):
	if player_chase and not dead and not player_in_range:
		var direction = (player.position - position).normalized()
		var velocity  = direction * speed * get_physics_process_delta_time()
		move_and_collide(velocity)


func player_attack(amount: int, enemy_element: Elements.Element):
	print("damage")
	health -=  round(amount * Elements.get_element_multiplier(enemy_element, element))
	if health <= 0:
		dead = true
		set_process(false)
		animation_tree["parameters/conditions/death"] = true
		await get_tree().create_timer(2.0).timeout
		queue_free()


func set_data():
	pass


func enemy():
	pass


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_chase = true
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/idle"] = false


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
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
