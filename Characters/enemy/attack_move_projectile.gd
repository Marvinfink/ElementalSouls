extends "res://Characters/enemy/base_enemy.gd"

var shooting: bool = false

const marksman_projectile := preload("res://Characters/projectile/marksman_projectile.tscn")

func shoot():
	if player_in_range and enemy_attack_cooldown and not dead and not shooting:
		shooting = true
		enemy_attack_cooldown = false
		await get_tree().create_timer(1).timeout
		
		var projectile := marksman_projectile.instantiate()
		owner.add_child(projectile)
		projectile.position = $Marker2D.global_position  # Setze die Position des Projektils
		
		# Setze die Richtung des Projektils in Richtung des Spielers
		projectile.transform = $Marker2D.transform
		
		$attack_cooldown.start()
		shooting = false
		
func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_range = true

func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_range = false
	
func _on_enemy_hitbox_body_entered(body):
	pass

func _on_enemy_hitbox_body_exited(body):
	pass
