extends "res://enemy/base/base_enemy.gd"

@onready var shooting_helper = preload("res://Enemy/helper/attack_move_projectile.gd").new()


func set_helper():
	shooting_helper.set_node(self)
	

func update_blend_position():
	var direction = player.position - position
	var direction_normalized = direction.normalized()
	animation_tree["parameters/attack/blend_position"] = direction_normalized
	animation_tree["parameters/damage/blend_position"] = direction_normalized
	animation_tree["parameters/death/blend_position"] = direction_normalized
	#animation_tree["parameters/walk/blend_position"] = direction_normalized


func _on_shooting_area_body_entered(body):
	if body.has_method("player"):
		player_in_range = true


func _on_shooting_area_body_exited(body):
	if body.has_method("player"):
		player_in_range = false
