extends Control

var sprites = []
var input_word = ""
var input_sprites = []
const CELL_SIZE = Vector2(50, 50)
var GRID_SIZE = 10

#generators
var spriteGen = preload("res://HunieStuff/Letter_Sprite.gd")
var wordGen = preload("res://HunieStuff/WordGeneration.gd").new()
var powers = preload("res://HunieStuff/Powers.gd").new()

func get_letters():
	var grid = []
	for row in sprites:
		var subGrid = []
		for col in row:
			subGrid.append(col.text)
		grid.append(subGrid)
	return grid

func create():
	for row in range(GRID_SIZE):
		var subsprites = []
		for col in range(GRID_SIZE):
			var sprite = spriteGen.new(row, col)
			subsprites.append(sprite)
			add_child(sprite)
		sprites.append(subsprites)
	
func check_for_selected_sprites(mouse_pos, dir):
	for row in sprites:
		for check_sprite in row:
			var check = check_sprite.check_sprite_click(mouse_pos)
			if check:
				return check_sprite
	return null

func move_sprites():
	for col in range(len(sprites[0])):
		for row in range(len(sprites)-1, -1, -1):
			var sprite = sprites[row][col]
			if sprite.get_letter() == "":
				for j in range(row - 1, -1, -1):
					var above = sprites[j][col]
					if above.get_letter() != "":
						# Store the original position
						var original_pos = sprite.position
						var above_pos = above.position
						
						# Move the text down
						sprite.set_letter(above.get_letter())
						above.set_letter("")
						
						sprite.move_sprite(original_pos, above_pos)
						break
				if sprite.get_letter() == "":
					sprite.new_gen()
					# Optionally animate new characters falling from above the screen
					var above_pos = Vector2(sprite.position.x, -CELL_SIZE.y)
					var original_pos = sprite.position
					sprite.move_sprite(original_pos, above_pos)
	print(wordGen.find_words_with_bruteforce(sprites))

func change_sprites():
	for row in sprites:
		for col in row:
			if col != null:
				col.deselect()

func move_sprites_with_direction(sprite, direction, buffer):
	var sprite_pos = sprite.position
	var viewport_mouse_pos = get_viewport().get_mouse_position()
	var movement = 0
	
	print(viewport_mouse_pos - sprite.old_pos)
	
	
	if viewport_mouse_pos.x - sprite.old_pos.x >= CELL_SIZE.x or viewport_mouse_pos.y - sprite.old_pos.y >= CELL_SIZE.y:
		movement = max(viewport_mouse_pos.x - sprite.old_pos.x, viewport_mouse_pos.y - sprite.old_pos.y) / CELL_SIZE.y
	elif abs(viewport_mouse_pos.x - sprite.old_pos.x) >= CELL_SIZE.x or abs(viewport_mouse_pos.y - sprite.old_pos.y) >= CELL_SIZE.y:
		movement = min(viewport_mouse_pos.x - sprite.old_pos.x, viewport_mouse_pos.y - sprite.old_pos.y) / CELL_SIZE.y
	
	if direction == "vertical":
		var col = sprite.col  # Assuming sprite has a 'col' property
		
		for i in range(len(sprites)):
			var new_y = viewport_mouse_pos.y + buffer[i]
			sprites[i][col].position.y = new_y
		
		rotate_column(col, int(movement))
	else:
		var row = sprite.row  # Assuming sprite has a 'row' property
		
		for i in range(len(sprites[0])):
			var new_x = viewport_mouse_pos.x + buffer[i]
			sprites[row][i].position.x = new_x
		
		rotate_row(row, int(movement))
	
	#print_grid()
	
func rotate_row(row, num_move):
	var temp_row = []
	for i in range(len(sprites[row])):
		temp_row.append(sprites[row][(i + num_move + len(sprites[row])) % len(sprites[row])])
	
	for i in range(len(temp_row)):
		sprites[row][i] = temp_row[i]

func rotate_column(col, num_move):
	var temp_col = []
	for i in range(len(sprites)):
		temp_col.append(sprites[(i + num_move + len(sprites)) % len(sprites)][col])
	
	for i in range(len(temp_col)):
		sprites[i][col] = temp_col[i]
		
func print_grid():
	for row in sprites:
		var str = ""
		for col in row:
			if col.letter == "":
				str += " "
			else:
				str += col.letter
		print(str)

func clear_input():
	input_word = ""
	input_sprites = []

func pop_input():
	var return_val = false
	var bomb_sprites = []
	print(input_word)
	if wordGen.is_valid_word(input_word.to_lower()):
		#print(input_word)
		return_val = true
		if len(input_word) >= 3:
			if input_sprites[0].is_special == 'bomb':
				bomb_sprites.append(input_sprites[0])
			else:
				input_sprites[0].power_up()
			
			for i in range(1, len(input_sprites)):
				var sprite = input_sprites[i]
				if sprite.is_special == 'bomb':
					bomb_sprites.append(sprite)
					
				sprite.set_letter("")
		
		else:
			for sprite in input_sprites:
				if sprite.is_special == 'bomb':
					bomb_sprites.append(sprite)
				sprite.set_letter("")
		
		#print(bomb_sprites)
		for sprite in bomb_sprites:
			powers.destroy_area_around_letter(sprites, sprite)
		
		move_sprites()
		
	change_sprites()
	clear_input()
	return return_val
	
func swap_sprites(sprite1, sprite2):
	print("sprite1: " + sprite1.get_letter() + " - sprite2: " + sprite2.get_letter())
	var temp = sprite1.get_letter()
	var is_special = sprite1.is_special
	
	if is_special == 'virus':
		powers.virus_effect(sprites, sprite2, sprite1)
	elif sprite2.is_special == 'virus':
		powers.virus_effect(sprites, sprite1, sprite2)
		
	sprite1.set_letter(sprite2.get_letter())
	sprite2.set_letter(temp)
	sprite1.is_special = sprite2.is_special
	sprite2.is_special = is_special
	
	print("sprite1: " + sprite1.get_letter() + " - sprite2: " + sprite2.get_letter())
