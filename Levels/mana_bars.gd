extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dash_timer_timeout():
	$Mana_Bar_Dash.value += 1


func use_dash() -> bool: 
	if $Mana_Bar_Dash.value >= 50:
		$Mana_Bar_Dash.value -= 50
		return true
	return false


func use_spell() -> bool:
	if $Mana_Bar_Spell.value == 0:
		$Mana_Bar_Spell.value = 0
		return true
	return false


func load_spell():
	$Mana_Bar_Spell.value += 10
	print($Mana_Bar_Spell.value)
