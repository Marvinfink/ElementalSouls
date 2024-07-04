extends Control

@onready var under_normal := preload("res://Art/mystic_woods_free_2.1/overlay/ProgressUnder.png")
@onready var under_light_up := preload("res://Art/mystic_woods_free_2.1/overlay/ProgressMana.png")

func _ready():
	pass


func _process(delta):
	pass


func _on_dash_timer_timeout():
	$Mana_Bar_Dash.value += 1


func use_dash() -> bool: 
	if $Mana_Bar_Dash.value >= 50:
		$Mana_Bar_Dash.value -= 50
		return true
	light_up_mana_bar_dash()
	return false


func use_spell() -> bool:
	if $Mana_Bar_Spell.value == 100:
		$Mana_Bar_Spell.value = 0
		return true
	light_up_mana_bar_spell()
	return false


func light_up_mana_bar_dash():
	$Mana_Bar_Dash.texture_under = under_light_up
	await get_tree().create_timer(0.1).timeout
	$Mana_Bar_Dash.texture_under = under_normal


func light_up_mana_bar_spell():
	$Mana_Bar_Spell.texture_under = under_light_up
	await get_tree().create_timer(0.1).timeout
	$Mana_Bar_Spell.texture_under = under_normal

func load_spell():
	$Mana_Bar_Spell.value += 15
	print($Mana_Bar_Spell.value)
