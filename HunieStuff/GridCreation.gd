extends Node

var gridGen = preload('res://HunieStuff/LetterGrid.gd').new()
var score_labels = preload("res://HunieStuff/Cum_Score.gd")
var dragging = false
var drag_start = null
var selected_sprite = null
#var selected_sprites = null
var buffer_arr = null
var drag_axis = null

func set_parameters(grid_size):
	gridGen.GRID_SIZE = grid_size
	score_labels = score_labels.new(gridGen)

func _init():
	gridGen.wordGen.generate_words()

func _ready():
	gridGen.create()
	add_child(gridGen)
	
	add_child(score_labels)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dragging = true
			#var temp = gridGen.check_for_selected_sprites(event.position, 0)
			selected_sprite = gridGen.check_for_selected_sprites(event.position, 0)
			#selected_sprites = temp[0]
			#buffer_arr = temp[1]
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dragging = false
			#for selected_sprite in selected_sprites:
				#selected_sprite.deselect()
			selected_sprite.deselect()
			selected_sprite = null
			#selected_sprites = null
			drag_axis = null
			buffer_arr = []
	elif event is InputEventMouseMotion and dragging:
		if drag_axis == null:
			drag_axis = Input.get_last_mouse_velocity()
			#selected_sprite.move_sprite(drag_start, new_pos, drag_axis)
			#drag_start = new_pos
		else:
			print(drag_axis)
			var direction
			if abs(drag_axis.x) > abs(drag_axis.y):
				direction = "vertical"
			else:
				direction = "horizontal"
				
			var buffer = create_buffer(selected_sprite, direction)
			gridGen.move_sprites_with_direction(selected_sprite, direction, buffer)
			#for i in len(selected_sprites):
				#var selected_sprite = selected_sprites[i]
				#var new_pos = selected_sprite.position
				#if abs(drag_axis.x) > abs(drag_axis.y):
					#var new_mouse_pos = Vector2(get_viewport().get_mouse_position().x + buffer_arr[i], selected_sprite.position.y)
					#drag_axis = Vector2(Input.get_last_mouse_velocity().x, 0)					
					#new_pos = new_mouse_pos
				#else:
					#var new_mouse_pos = Vector2(selected_sprite.position.x, get_viewport().get_mouse_position().y + buffer_arr[i])
					#drag_axis = Vector2(0, Input.get_last_mouse_velocity().y)
					#new_pos = new_mouse_pos
				##new_pos = selected_sprite.position + (drag_axis * 10)
				#selected_sprite.move_sprite(new_pos)
			#drag_axis = Input.get_last_mouse_velocity()
			
		
func get_closer_axis(vector : Vector2):
	var Vect = Vector2.UP
	var  directions = [Vector2.UP , Vector2.DOWN , Vector2.LEFT , Vector2.RIGHT]
	for dir in directions :
		if abs(dir.angle_to(vector)) < abs(Vect.angle_to(vector)):
			Vect = dir
	return Vect

func create_buffer(sprite, direction):
	var buffer = []
	if direction == "vertical":
		for i in range(len(gridGen.sprites)):
			buffer.append((i - sprite.row) * sprite.CELL_SIZE.x)
	else:
		for i in range(len(gridGen.sprites[0])):
			buffer.append((i - sprite.col) * sprite.CELL_SIZE.x)
	return buffer
