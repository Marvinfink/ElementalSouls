extends "res://enemy/helper/base_helper.gd"

var sprint_direction
var sprint_target


func start_attack_move():
	if base.player_in_range and base.enemy_attack_cooldown and not base.states[Animations.IS_DEAD] and not base.states[Animations.IS_ATTACKING]:
		base.enemy_attack_cooldown = false
		await prepare_attack()


func prepare_attack():
	base.set_physics_process(false)
	base.set_state(Animations.IS_ATTACKING)
	base.update_blend_position()
	start_sprint()
	await base.get_tree().create_timer(base.attack_delay).timeout # Kurze Verzögerung vor dem Angriff
	base.set_physics_process(true)


func start_sprint():
	sprint_direction = (base.player.position - base.position).normalized()
	sprint_target = base.position + sprint_direction * base.sprint_distance


func move_sprint(delta: float):
	var step_distance: float = base.sprint_speed * delta
	base.position += sprint_direction * step_distance
	base.move_and_collide(sprint_direction * step_distance)

	if (base.position.distance_to(sprint_target) <= step_distance):
		base.set_state(Animations.IDLE)
		base.position = sprint_target
		base.start_attack_countdown()
		print("Attack move finished without damage")
	elif base.player_in_range:
		base.set_physics_process(false)
		attack_player()
		print("Attack move finished with damage")
		base.set_physics_process(true)


func attack_player():
	if base.states[Animations.IS_ATTACKING]:
		base.set_state(Animations.IDLE)
		base.player.enemy_attack(base.damage)
		base.start_attack_countdown()
