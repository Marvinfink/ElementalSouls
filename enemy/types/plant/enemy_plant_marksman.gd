extends "res://enemy/types/enemy_marksman.gd"

func set_type():
	$BodyMarksman.texture = preload("res://Art/mystic_woods_free_2.1/enemies/plantRanged.png")
	element = Elements.Element.PLANT
