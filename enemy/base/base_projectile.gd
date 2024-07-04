extends Area2D

# Eigenschaften für das Projektil
@export var speed: float
@export var range: float

# Interna
var distance_travelled: float = 0.0
var direction: Vector2 = Vector2.ZERO


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


func set_element(element: Elements.Element):
	match element:
		Elements.Element.FIRE:
			$Sprite2D.texture = preload("res://Art/SpecialAttack/fire_bullet.png")
		Elements.Element.WATER:
			$Sprite2D.texture = preload("res://Art/SpecialAttack/water_bullet.png")
		Elements.Element.PLANT:
			$Sprite2D.texture = preload("res://Art/SpecialAttack/plant_bullet.png")
		Elements.Element.ELECTRICITY:
			$Sprite2D.texture = preload("res://Art/SpecialAttack/electricity_bullet.png")
	
	
func set_direction(d: Vector2):
		d *= 10000
		direction = d.normalized()
		

func destroy():
	queue_free()
