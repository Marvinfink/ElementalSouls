# Marksman
extends "res://enemy/types/marksman.gd"
@onready var marksmanFly= $marksmanFly
@onready var marksmanAttack = $marksmanAttack
@onready var marksmanDeath = $marksmanDeath
@onready var marksmanDamage = $marksmanDamage

func set_data():
	health = 150
	speed = 60
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

func set_sound(state:String):
	match state: 
		Animations.IS_WALKING:
			if not marksmanFly.playing:
				marksmanFly.play()
		Animations.IDLE:
			marksmanFly.stop()
			marksmanDeath.stop()
			marksmanDamage.stop()
		Animations.IS_DEAD:
			marksmanDeath.play()
		Animations.GETS_DAMAGE:
			marksmanDamage.play()	
		Animations.IS_ATTACKING:
			marksmanAttack.play()
