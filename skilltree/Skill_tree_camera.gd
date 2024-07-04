extends Camera2D


const ZOOM_SPEED = 1
const MIN_ZOOM = 3.0
const MAX_ZOOM = 1.0

var dragging : bool = false 
var last_clicked_pos : Vector2 = Vector2(0,0)

func _ready():
	self.zoom = Vector2(1,1)

func _input(event):
	# Zooming	
	if Input.is_action_pressed("Skilltree_zoom_in"):
		var zoom = self.zoom.x
		zoom = max(MIN_ZOOM, zoom - ZOOM_SPEED)
		self.zoom = Vector2(zoom,zoom)
	
	if Input.is_action_pressed("Skilltree_zoom_out"):
		var zoom = self.zoom.x
		zoom = min(MAX_ZOOM, zoom - ZOOM_SPEED)
		self.zoom = Vector2(zoom,zoom)
	
	
	# Dragging	
	if Input.is_action_pressed("Skilltree_left_klick"):
		if not dragging:
			last_clicked_pos = event.position
		dragging = true 
		var delta : Vector2 =  event.position - last_clicked_pos
		last_clicked_pos = event.position
		self.position = self.position - delta
		
	elif Input.is_action_just_released("Skilltree_left_klick"):
		dragging = false
