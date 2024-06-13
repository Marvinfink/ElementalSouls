# Marksman
extends "res://Enemy/attacks/attack_move_projectile.gd"

func set_data():
	health = 150
	speed = 60
	damage = 0.5
	element = Elements.Element.WATER
	cooldown = 3

# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	shoot()
	if not shooting:
		move_position(delta)


# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass

