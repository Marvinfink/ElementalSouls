extends "res://enemy/base/base_enemy.gd"

var player_in_shooting_range: bool

@onready var spell_helper = preload("res://enemy/helper/attack_move_projectile.gd").new()


func set_helper():
    spell_helper.set_node(self)


func _on_shooting_area_body_entered(body):
    if body.has_method("player"):
        player_in_shooting_range = true


func _on_shooting_area_body_exited(body):
    if body.has_method("player"):
        player_in_shooting_range = false


func set_data():
    health = 150
    speed = 60
    damage = 0.5
    cooldown = 3
    animation_tree = $AnimationTreeMarksman


func set_type():
    $BodyMarksman.texture = preload("res://Art/mystic_woods_free_2.1/enemies/plant_boss.png")
    element = Elements.Element.PLANT


# für physikalische Berechnungen und Logik, die präzise Synchronisation erfordert, wie Bewegungen und Kollisionen
func _physics_process(delta: float) -> void:
    update_blend_position()
    spell_helper.shoot()
    if not states[Animations.IS_ATTACKING]:
        move_position(delta)


# für nicht-physikalische Logik wie Animationen, UI-Updates, nicht-physikbasierte Bewegungen
func _process(delta: float) -> void:
    pass