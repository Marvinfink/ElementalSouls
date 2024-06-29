extends "res://enemy/base/base_enemy.gd"

# attack move sprint
var sprint_distance: int
var sprint_speed: int
var attack_delay: float

@onready var charging_helper = preload("res://enemy/helper/attack_move_sprint.gd").new()


func set_helper():
	charging_helper.set_node(self)
