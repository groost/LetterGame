const CELL_SIZE = Vector2(50, 50)

func destroy_area_around_letter(sprites, special_sprite):
	var pos = special_sprite.position / CELL_SIZE
	var row = int(pos.y) - 1
	var col = int(pos.x) - 1
	
	#print("row: " + str(row) + " - col: " + str(col))
	for r in range(row - 1, row + 2):
		for c in range(col - 1, col + 2):
			if r >= 0 and r < 10 and c >= 0 and c < 10:
				var label_node = sprites[r][c]
				if label_node:
					label_node.set_letter("")
	
	special_sprite.is_special = ''

func virus_effect(sprites, clean_sprite, virus_sprite):
	var return_sprites = []
	
	for row in sprites:
		for sprite in row:
			if sprite.letter == clean_sprite.letter:
				return_sprites.append(sprite)
	
	for sprite in return_sprites:
		sprite.set_letter(virus_sprite.letter)
	
	virus_sprite.is_special = ''
