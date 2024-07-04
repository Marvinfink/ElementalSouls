extends Area2D

var created_by_player: bool
var stage_one: bool
var damage
var element
var bodies = []
@onready var count = 0
@onready var boltSound = $boltSound

# Called when the node enters the scene tree for the first time.
func _ready():
	boltSound.play()
	element = Elements.Element.ELECTRICITY
	stage_one = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func create(damage: int, created_by_player: bool):
	self.damage = damage
	self.created_by_player = created_by_player


func _on_body_entered(body):
	if not stage_one:
		bodies.append(body)
		return
	check_damage(body)
	

func _on_body_exited(body):
	if not stage_one:
		bodies.erase(body)


func check_damage(body):
	if body == null:
		return
	if created_by_player:
		if body.has_method("enemy"):
			body.player_attack(damage, element)
			count += 1
	else:
		if body.has_method("player"):
			body.enemy_attack()
			count += 1
	if count >= 3:
		destroy()


func destroy():
	queue_free()


func _on_death_timer_timeout():
	destroy()


func _on_stage_one_timeout():
	stage_one = true
	for b in bodies:
		bodies.erase(b)
		check_damage(b)
