# Allrounder.gd
extends "res://Characters/enemy/attack_move_projectile.gd"

func set_data():
	health = 200
	speed = 60
	damage = 0.5
	element = Elements.Element.WATER
	cooldown = 1

# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	$Node2D.look_at(player.position)
	shoot()
	if not shooting:
		move_position(delta)


# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass

