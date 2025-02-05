# Allrounder.gd
extends "res://enemy/types/fighter.gd"

@onready var tankStomp = $tankStomp
@onready var tankAttack = $tankAttack
@onready var tankDeath = $tankDeath
@onready var tankDamage = $tankDamage

func set_data():
	health = 200
	speed = 60
	cooldown = 3
	attack_delay = 0.5
	sprint_speed = 130
	sprint_distance = 50
	animation_tree = $AnimationTreeTank


# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
	if states[Animations.IS_ATTACKING]:
		charging_helper.move_sprint(delta)
	else:
		update_blend_position()
		move_position(delta)
		charging_helper.start_attack_move()


# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
	pass


func set_sound(state:String):
	match state: 
		Animations.IS_WALKING:
			if not tankStomp.playing:
				tankStomp.play()
		Animations.IDLE:
			tankStomp.stop()
			tankDeath.stop()	
			tankDamage.stop()
		Animations.IS_DEAD:
			tankDeath.play()
		Animations.GETS_DAMAGE:
			tankDamage.play()	
		Animations.IS_ATTACKING:
			tankAttack.play()
