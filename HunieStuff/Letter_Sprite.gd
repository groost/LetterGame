extends Letter

var row
var col
var old_pos
const CELL_SIZE = Vector2(50, 50)
var letter_textures = {}
var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var is_clicked = false

func _init(row, col):
	init_textures()
	
	position = Vector2(col+1, row+1) * CELL_SIZE
	old_pos = position
	name = str(row) + "_" + str(col)
	self.row = row
	self.col = col
	
	generate_letter()
	set_letter_texture()
	

func init_textures():
	for let in letters:
		if not let in letter_textures:
			var image_path = "res://Letters/" + let + "-Key.png"
			var image = Image.load_from_file(image_path)
			var sprite_texture = ImageTexture.create_from_image(image)
			letter_textures[let] = sprite_texture
	
	var image_path = "res://Letters/Wildcard-Key.png"
	var image = Image.load_from_file(image_path)
	var sprite_texture = ImageTexture.create_from_image(image)
	letter_textures["?"] = sprite_texture
	
func set_letter_texture():
	init_textures()
	if is_special == 'bomb':
		power_up()
	else:
		texture = letter_textures[letter]
		
	region_enabled = true
	region_rect = Rect2(0, 0, 32, 32)

func new_gen():
	generate_letter()
	set_letter_texture()

func select():
	region_rect = Rect2(32, 0, 32, 32)
	is_clicked = true
	pass
	
func deselect():
	region_rect = Rect2(0, 0, 32, 32)
	is_clicked = false
	pass

func check_sprite_click(mouse_pos):
	var sprite_rect = Rect2(position - CELL_SIZE / 2, CELL_SIZE)
	if sprite_rect.has_point(mouse_pos) and not is_clicked:
		select()
		print("Sprite clicked:", name)
		return true
	return false

func move_sprite(new_pos):
	create_tween().tween_property(self, "position", new_pos, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	position = new_pos

func power_up():
	is_special = 'bomb'
	var image_path = "res://Letters/" + letter + "-Bomb-Key.png"
	var image = Image.load_from_file(image_path)
	var sprite_texture = ImageTexture.create_from_image(image)
	
	texture = sprite_texture
	# Add logic to visually indicate the power-up state

func set_letter(let):
	letter = let
	if let != '':
		set_letter_texture()

func get_letter():
	return letter
