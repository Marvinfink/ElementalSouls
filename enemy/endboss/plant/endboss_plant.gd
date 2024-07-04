extends "res://enemy/base/base_enemy.gd"

var player_in_shooting_range: bool
var spell_ready: bool

const thorn_projectile := preload("res://enemy/projectile/thorns.tscn")

func _on_spell_timer_timeout():
	spell_ready = true
	

func set_helper():
	pass


func _on_shooting_area_body_entered(body):
	if body.has_method("player"):
		player_in_shooting_range = true


func _on_shooting_area_body_exited(body):
	pass


func set_data():
	health = 500
	speed = 40
	cooldown = 1
	animation_tree = $AnimationTreeEndboss
	states[Animations.USING_SPECIAL_ATTACK] = false
	blends.append(Animations.BLEND_SPECIAL_ATTACK)


func set_type():
	$BodyEndboss.texture = preload("res://Art/pixelart/enemies/plant_boss.png")
	element = Elements.Element.PLANT


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
		var position = player.global_position
		await get_tree().create_timer(0.6).timeout
		var projectile := thorn_projectile.instantiate()
		projectile.created_by_player = false
		projectile.global_position = position
		owner.add_child(projectile)
	start_spell_timer()
	set_physics_process(false)
	await get_tree().create_timer(2).timeout
	set_physics_process(true)
	set_state(Animations.IDLE)

		
func attack_player():
	set_state(Animations.IS_ATTACKING)
	await get_tree().create_timer(0.3).timeout
	player.enemy_attack()
	start_attack_countdown()
	set_state(Animations.IDLE)

# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass
	

func start_spell_timer():
	$spell_timer.start()
	
	
func _on_attack_body_entered(body):
	pass

func _on_attack_body_exited(body):
	pass
