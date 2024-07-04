extends CharacterBody2D
#base enemy

# variable for each enemy
@export var health: int
@export var speed: int
@export var element: Elements.Element
@export var cooldown: float

# set in base
var player_in_range: bool
var player_chase: bool
var enemy_attack_cooldown: bool
var player: Node
var states: Dictionary
var blends: Array = []

@onready var animation_tree
@onready var stompSound = $stompSound


func _ready():
	set_data()
	set_type()
	set_dictionaries()
	set_helper()
	player_in_range = false
	player_chase = false
	enemy_attack_cooldown = true
	player = get_node("../Player1")
	$attack_cooldown.wait_time = cooldown


func move_position(delta: float):
	if player_chase and not states[Animations.IS_DEAD] and not player_in_range:
		set_state(Animations.IS_WALKING)
		var direction = (player.position - position).normalized()
		var velocity  = direction * speed * get_physics_process_delta_time()
		move_and_collide(velocity)


func player_attack(amount: int, enemy_element: Elements.Element):
	health -=  round(amount * Elements.get_element_multiplier(enemy_element, element))
	if health <= 0:
		set_state(Animations.IS_DEAD)
		set_process(false)
		await get_tree().create_timer(1).timeout
		queue_free()
		return
	set_state(Animations.GETS_DAMAGE)
	await get_tree().create_timer(0.5).timeout
	set_state(Animations.IDLE)


func start_attack_countdown():
	$attack_cooldown.start()


func set_data():
	pass
	
	
func set_type():
	pass


func set_helper():
	pass


func enemy():
	pass
	

func set_dictionaries():
	states[Animations.IDLE] = true
	states[Animations.GETS_DAMAGE] = false
	states[Animations.IS_WALKING] = false
	states[Animations.IS_ATTACKING] = false
	states[Animations.IS_DEAD] = false
	blends.append(Animations.BLEND_ATTACK)
	blends.append(Animations.BLEND_DAMAGE)
	blends.append(Animations.BLEND_DEATH)
	blends.append(Animations.BLEND_WALK)
	
	
func update_blend_position():
	var direction = player.position - position
	var direction_normalized = direction.normalized()
	for b in blends:
		animation_tree["parameters/%s/blend_position" % b] = direction_normalized


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_chase = true
		set_state(Animations.IS_WALKING)


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_chase = false
		set_state(Animations.IDLE)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false


func set_state(state: String):
	for a in states:
		states[a] = false
	states[state] = true
	set_animation(state)
	set_sound(state)


func set_animation(animation: String):
	for a in states:
		animation_tree["parameters/conditions/%s" % a] = false
	animation_tree["parameters/conditions/%s" % animation] = true

func set_sound(state:String):
	pass
		
					
