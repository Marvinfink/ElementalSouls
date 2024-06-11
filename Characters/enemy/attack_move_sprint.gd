extends "res://Characters/enemy/base_enemy.gd"

# variable for each enemy
@export var sprint_distance: int
@export var sprint_speed: int
@export var attack_delay: float
# set in base
var attack_move: bool = false
var sprint_direction
var sprint_target


func start_attack_move():
	if player_in_range and enemy_attack_cooldown and not dead and not attack_move:
		enemy_attack_cooldown = false
		#animation_tree["parameters/conditions/attack"] = true
		await prepare_attack()
		#animation_tree["parameters/conditions/attack"] = false


func prepare_attack():
	set_physics_process(false)
	attack_move = true
	start_sprint()
	await get_tree().create_timer(attack_delay).timeout # Kurze Verzögerung vor dem Angriff
	set_physics_process(true)


func start_sprint():
	sprint_direction = (player.position - position).normalized()
	sprint_target = position + sprint_direction * sprint_distance


func move_sprint(delta: float):
		var step_distance: float = sprint_speed * delta
		position += sprint_direction * step_distance
		move_and_collide(sprint_direction * step_distance)

		if (position.distance_to(sprint_target) <= step_distance):
			position = sprint_target
			attack_move = false
			$attack_cooldown.start()
			print("Attack move finished")
		elif player_in_range:
			set_physics_process(false)
			attack_player()
			print("Attack move finished")
			set_physics_process(true)


func attack_player():
	if attack_move:
		player.enemy_attack(damage)
		attack_move = false
		$attack_cooldown.start()
		
