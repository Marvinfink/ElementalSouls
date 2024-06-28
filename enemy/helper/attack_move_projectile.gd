extends "res://enemy/helper/base_helper.gd"

const marksman_projectile := preload("res://Enemy/projectile/marksman_projectile.tscn")


func shoot():
	if base.player_in_range and base.enemy_attack_cooldown and not base.dead and not base.states[Animations.IS_ATTACKING]:
		base.set_state(Animations.IS_ATTACKING)
		base.enemy_attack_cooldown = false
		await base.get_tree().create_timer(0.6).timeout
		base.set_state(Animations.IDLE)
		var projectile := marksman_projectile.instantiate()
		base.owner.add_child(projectile)
		projectile.position = base.global_position
		projectile.rotation = base.global_position.direction_to(base.player.global_position).angle()
		base.set_state(Animations.IDLE)
		base.start_attack_countdown()
		
	
func _on_enemy_hitbox_body_entered(body):
	pass

func _on_enemy_hitbox_body_exited(body):
	pass
