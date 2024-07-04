extends CanvasLayer

@onready var menubutton = $MenuButton
@onready var selected_element: Elements.Element = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	var water_icon := scale_texture(load("res://Art/pixelart/overlay/Wasser-Elementpng.png"), Vector2(32, 32))
	var fire_icon := scale_texture(load("res://Art/pixelart/overlay/Feuer_Element.png"), Vector2(32, 32))
	var plant_icon := scale_texture(load("res://Art/pixelart/overlay/Pflanze-Element.png"), Vector2(32, 32))
	var electricity_icon := scale_texture(load("res://Art/pixelart/overlay/Elektro_Element.png"), Vector2(32, 32))
	
	var popup = menubutton.get_popup()
	popup.id_pressed.connect(menu_button_selected)
	popup.add_icon_item(water_icon, "Wasser", Elements.Element.WATER)
	popup.add_icon_item(fire_icon, "Feuer", Elements.Element.FIRE)
	popup.add_icon_item(plant_icon, "Pflanze", Elements.Element.PLANT)
	popup.add_icon_item(electricity_icon, "Elektro", Elements.Element.ELECTRICITY)
	get_tree().paused = true
	self.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func show_main_menu():
	get_tree().paused = true
	get_tree().reload_current_scene()
	$MenuButton.text = "Wähle..."
	selected_element = -1
	self.show()


func _on_button_pressed():
	if selected_element != -1:
		get_tree().paused = false
		self.hide()
		get_node("../Player1").set_first_element(selected_element)
		return 
	$Error.text = "Bitte wähle ein Element!"

func menu_button_selected(id): 
	var selected_text: String
	match id:
		Elements.Element.FIRE:
			selected_text = "Feuer"
		Elements.Element.WATER:
			selected_text = "Wasser"
		Elements.Element.PLANT:
			selected_text = "Pflanze"
		Elements.Element.ELECTRICITY:
			selected_text = "Elektro"
	$MenuButton.text = selected_text
	$Error.text = ""
	selected_element = id

func scale_texture(texture: Texture, new_size: Vector2) -> ImageTexture:
	var image = texture.get_image()
	image.resize(new_size.x, new_size.y, Image.INTERPOLATE_BILINEAR)
	var new_texture = ImageTexture.new()
	new_texture.create_from_image(image)
	return new_texture
