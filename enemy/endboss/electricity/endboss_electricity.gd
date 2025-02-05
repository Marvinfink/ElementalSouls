extends "res://enemy/base/base_endboss.gd"

const thorn_projectile := preload("res://enemy/projectile/bolt.tscn")

func set_data():
	health = 500
	speed = 40
	cooldown = 1
	animation_tree = $AnimationTreeEndboss
	states[Animations.USING_SPECIAL_ATTACK] = false
	blends.append(Animations.BLEND_SPECIAL_ATTACK)


func set_type():
	$BodyEndboss.texture = preload("res://Art/mystic_woods_free_2.1/enemies/ElectroBossSheet.png")
	element = Elements.Element.ELECTRICITY


# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	if states[Animations.IS_DEAD]:
		return
	update_blend_position()
	if spell_ready and not states[Animations.IS_ATTACKING] and player_in_shooting_range:
		spell_ready = false
		use_spell(5)
	elif enemy_attack_cooldown and player_in_range and not states[Animations.USING_SPECIAL_ATTACK]:
		enemy_attack_cooldown = false
		attack_player()
	elif not states[Animations.IS_ATTACKING] and not states[Animations.USING_SPECIAL_ATTACK]:
		move_position(delta)


func use_spell(times: int):
	var angle = randi_range(0, 2 * PI)
	for x in range(times):
		set_state(Animations.USING_SPECIAL_ATTACK)
		var projectile := thorn_projectile.instantiate()
		var position = self.global_position
		var half_width = 60
		var offset = Vector2(half_width, 0).rotated(angle)
		projectile.rotation = angle
		projectile.global_position = position + offset
		projectile.created_by_player = false
		owner.add_child(projectile)
		angle += PI / 3
	start_spell_timer()
	set_physics_process(false)
	await get_tree().create_timer(3).timeout
	set_physics_process(true)
	set_state(Animations.IDLE)


# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass
