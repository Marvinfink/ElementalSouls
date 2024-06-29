# Marksman
extends "res://enemy/types/marksman.gd"

func set_data():
	health = 150
	speed = 60
	damage = 0.5
	element = Elements.Element.WATER
	cooldown = 3
	$BodyMarksman.texture = preload("res://Art/mystic_woods_free_2.1/enemies/FireRanged.png")
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
