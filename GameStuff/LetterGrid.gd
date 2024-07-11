extends Control

var sprites = []
var input_word = ""
var input_sprites = []
const CELL_SIZE = Vector2(50, 50)
var GRID_SIZE = 10

#generators
var spriteGen = preload("res://GameStuff/Letter_Sprite.gd")
var wordGen = preload("res://GameStuff/WordGeneration.gd").new()
var powers = preload("res://GameStuff/Powers.gd").new()

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
	
func check_for_selected_sprites(mouse_pos):
	for row in sprites:
		for sprite in row:
			var check = sprite.check_sprite_click(mouse_pos)
			if check:
				input_sprites.append(sprite)
				input_word += sprite.get_letter()
				return sprite
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
