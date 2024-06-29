extends "res://enemy/types/enemy_marksman.gd"

func set_type():
	$BodyMarksman.texture = preload("res://Art/mystic_woods_free_2.1/enemies/waterRanged.png")
	element = Elements.Element.WATER
