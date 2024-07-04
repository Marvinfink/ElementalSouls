extends "res://enemy/base/base_enemy.gd"

var player_in_shooting_range: bool
var spell_ready: bool


func destroy():
	player.endboss_killed(element)
	queue_free()
	

func attack_player():
	set_state(Animations.IS_ATTACKING)
	await get_tree().create_timer(0.3).timeout
	player.enemy_attack()
	start_attack_countdown()
	set_state(Animations.IDLE)


func _on_shooting_area_body_entered(body):
	if body.has_method("player"):
		player_in_shooting_range = true


func _on_shooting_area_body_exited(body):
	if body.has_method("player"):
		player_in_shooting_range = false


func _on_spell_timer_timeout():
	spell_ready = true


func start_spell_timer():
	$spell_timer.start()
