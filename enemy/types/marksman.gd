extends "res://enemy/base/base_enemy.gd"
var player_in_shooting_range: bool

@onready var shooting_helper = preload("res://Enemy/helper/attack_move_projectile.gd").new()


func set_helper():
	shooting_helper.set_node(self)


func _on_shooting_area_body_entered(body):
	if body.has_method("player"):
		player_in_shooting_range = true


func _on_shooting_area_body_exited(body):
	if body.has_method("player"):
		player_in_shooting_range = false
