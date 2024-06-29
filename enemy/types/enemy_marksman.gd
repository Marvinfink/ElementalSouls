# Marksman
extends "res://enemy/types/marksman.gd"

func set_data():
	health = 150
	speed = 60
	damage = 0.5
	cooldown = 3
	animation_tree = $AnimationTreeMarksman

# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	update_blend_position()
	shooting_helper.shoot()
	if not states[Animations.IS_ATTACKING]:
		move_position(delta)


# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass
