extends "res://enemy/helper/base_helper.gd"

const marksman_projectile := preload("res://enemy/projectile/marksman_projectile.tscn")


func shoot():
	if base.player_in_shooting_range and base.enemy_attack_cooldown and not base.states[Animations.IS_DEAD] and not base.states[Animations.IS_ATTACKING]:
		base.set_state(Animations.IS_ATTACKING)
		base.enemy_attack_cooldown = false
		await base.get_tree().create_timer(0.6).timeout
		
		# Erstellen und hinzufügen des Projektils
		var projectile := marksman_projectile.instantiate()
		projectile.set_element(base.element)
		projectile.global_position = base.global_position
		projectile.rotation = base.global_position.direction_to(base.player.global_position).angle()
		projectile.direction = base.player.global_position - base.global_position # Zielposition für das Projektil
		
		base.owner.add_child(projectile)
		
		base.set_state(Animations.IDLE)
		base.start_attack_countdown()


func _on_enemy_hitbox_body_entered(body):
	pass

func _on_enemy_hitbox_body_exited(body):
	pass
