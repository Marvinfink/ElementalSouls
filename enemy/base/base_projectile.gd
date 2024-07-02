extends Area2D

# Eigenschaften für das Projektil
@export var speed: float
@export var range: float
@export var stun_duration: int
@export var knockback_force: int

# Interna
var distance_travelled: float = 0.0
var direction: Vector2 = Vector2.ZERO

# Referenzen
@onready var hitbox = $Hitbox

func _physics_process(delta):
	if distance_travelled > range:
		queue_free()
	else:
		var step = speed * delta * direction
		distance_travelled += step.length()
		global_position += step

func _on_body_entered(body):
	if body.has_method("enemy"):
		return
	elif body.has_method("player"):
		body.enemy_attack()
	destroy()
	
func destroy():
	queue_free()
