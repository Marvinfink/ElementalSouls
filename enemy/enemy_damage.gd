extends "res://enemy/types/fighter.gd"

func set_data():
	health = 150
	speed = 60
	damage = 1
	element = Elements.Element.WATER
	cooldown = 1.5
	attack_delay = 0.5
	sprint_speed = 120
	sprint_distance = 60


# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	if charging_helper.attack_move:
		charging_helper.move_sprint(delta)
	else:
		move_position(delta)
		charging_helper.start_attack_move()


# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass
