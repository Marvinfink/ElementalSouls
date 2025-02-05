extends "res://enemy/base/base_endboss.gd"

const wave_projectile := preload("res://enemy/projectile/wave.tscn")

func set_data():
	health = 500
	speed = 40
	cooldown = 1
	animation_tree = $AnimationTreeEndboss
	states[Animations.USING_SPECIAL_ATTACK] = false
	blends.append(Animations.BLEND_SPECIAL_ATTACK)


func set_type():
	$BodyEndboss.texture = preload("res://Art/mystic_woods_free_2.1/enemies/water_boss.png")
	element = Elements.Element.WATER


# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	if states[Animations.IS_DEAD]:
		return
	update_blend_position()
	if spell_ready and not states[Animations.IS_ATTACKING] and player_in_shooting_range:
		spell_ready = false
		use_spell(3)
	elif enemy_attack_cooldown and player_in_range and not states[Animations.USING_SPECIAL_ATTACK]:
		enemy_attack_cooldown = false
		attack_player()
	elif not states[Animations.IS_ATTACKING] and not states[Animations.USING_SPECIAL_ATTACK]:
		move_position(delta)
		
		
func use_spell(times: int):
	for x in range(times):
		set_state(Animations.USING_SPECIAL_ATTACK)
		await get_tree().create_timer(0.6).timeout
		var projectile := wave_projectile.instantiate()
		projectile.global_position = self.global_position
		projectile.set_direction(player.global_position - global_position)
		var angle = global_position.direction_to(player.global_position).angle()
		if abs(angle) >= PI/2 :
			projectile.scale.y = -1
		projectile.rotation = angle
		projectile.created_by_player = false
		owner.add_child(projectile)
	start_spell_timer()
	set_physics_process(false)
	await get_tree().create_timer(2).timeout
	set_physics_process(true)
	set_state(Animations.IDLE)

# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass
