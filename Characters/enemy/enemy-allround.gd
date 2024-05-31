# Allrounder.gd
extends "res://Characters/enemy/base-enemy.gd"

func set_data():
	health = 200
	speed = 60
	damage = 0.5
	element = 0
	cooldown = 1

# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	move_position()
	attack()

# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass
