# EnemySpawner.gd
extends Node2D

# Lade die Gegnerszenen
var AllrounderScene = preload("res://Allrounder.tscn")
var TankScene = preload("res://Tank.tscn")
var RogueScene = preload("res://Rogue.tscn")
var MageScene = preload("res://Mage.tscn")

# Funktion zum Erstellen von Gegnern
func spawn_enemy(enemy_type, position):
    var enemy_instance
    match enemy_type:
        "Allrounder":
            enemy_instance = AllrounderScene.instance()
        "Tank":
            enemy_instance = TankScene.instance()
        "Rogue":
            enemy_instance = RogueScene.instance()
        "Mage":
            enemy_instance = MageScene.instance()
    if enemy_instance:
        add_child(enemy_instance)
        enemy_instance.position = position

# Beispiel zum Spawnen von Gegnern an bestimmten Positionen
func _ready():
    spawn_enemy("Allrounder", Vector2(100, 100))
    spawn_enemy("Tank", Vector2(200, 100))
    spawn_enemy("Rogue", Vector2(300, 100))
    spawn_enemy("Mage", Vector2(400, 100))
