# Marksman
extends Node

@onready var shooting_helper = preload("res://Enemy/attacks/attack_move_projectile.gd").new()
@onready var charging_helper = preload("res://Enemy/attacks/attack_move_sprint.gd").new()

func set_data():
	pass
# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	shooting_helper.shoot()


# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass

