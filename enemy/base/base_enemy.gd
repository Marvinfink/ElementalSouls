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
var states: Dictionary

@onready var animation_tree = $AnimationTree


func _ready():
	states[Animations.IDLE] = true
	states[Animations.GETS_DAMAGE] = false
	states[Animations.IS_WALKING] = false
	states[Animations.IS_ATTACKING] = false
	set_data()
	set_helper()
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
	health -=  round(amount * Elements.get_element_multiplier(enemy_element, element))
	animation_tree["parameters/conditions/get_damage"] = true
	if health <= 0:
		dead = true
		set_process(false)
		animation_tree["parameters/conditions/is_dead"] = true
		await get_tree().create_timer(1.0).timeout
		queue_free()


func start_attack_countdown():
	$attack_cooldown.start()


func set_data():
	pass


func set_helper():
	pass


func enemy():
	pass


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_chase = true
		set_animation(Animations.IS_WALKING)


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_chase = false
		set_animation(Animations.IDLE)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false


func set_state(state: String):
	for a in states.values():
		a = false
	states[state] = true
	set_animation(state)


func set_animation(animation: String):
	for a in states.keys():
		animation_tree["parameters/conditions/%s" % a] = false
	animation_tree["parameters/conditions/%s" % animation] = true



	
