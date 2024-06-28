extends "res://enemy/base/base_enemy.gd"

# attack move sprint
var sprint_distance: int
var sprint_speed: int
var attack_delay: float

@onready var charging_helper = preload("res://enemy/helper/attack_move_sprint.gd").new()

func update_blend_position():
	var direction = player.position - position
	var direction_normalized = direction.normalized()
	animation_tree["parameters/attack/blend_position"] = direction_normalized
	animation_tree["parameters/damage/blend_position"] = direction_normalized
	animation_tree["parameters/death/blend_position"] = direction_normalized
	#animation_tree["parameters/walk/blend_position"] = direction_normalized


func set_helper():
	charging_helper.set_node(self)
