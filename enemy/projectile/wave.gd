extends Area2D

# Eigenschaften für das Projektil
@export var speed: float = 50
@export var range: float = 200
var element: Elements.Element = Elements.Element.WATER

# Interna
var distance_travelled: int = 0.0
var direction: Vector2 = Vector2.ZERO
var created_by_player: bool
var damage

func create(damage: int, created_by_player: bool):
	self.damage = damage
	self.created_by_player = created_by_player


func set_direction(d: Vector2):
		d *= 10000
		direction = d.normalized()


func _physics_process(delta):
	if distance_travelled > range:
		queue_free()
	else:
		var step = speed * delta * direction
		distance_travelled += step.length()
		global_position += step


func _on_body_entered(body):
	if created_by_player:
		if body.has_method("enemy"):
			body.player_attack(damage, element)
	else:
		if body.has_method("player"):
			body.enemy_attack()
	if not body.has_method("enemy") and not body.has_method("player"):
		destroy()


func destroy():
	queue_free()
