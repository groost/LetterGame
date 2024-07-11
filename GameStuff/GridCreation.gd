extends Node

var gridGen = preload('res://GameStuff/LetterGrid.gd').new()
var score_labels = preload("res://GameStuff/Cum_Score.gd").new(gridGen)
var pressed = false
var swap_sprite = null

func set_parameters(grid_size):
	gridGen.GRID_SIZE = grid_size

func _init():
	gridGen.wordGen.generate_words()

func _ready():
	gridGen.create()
	add_child(gridGen)
	
	add_child(score_labels)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			pressed = true
			var sprite = gridGen.check_for_selected_sprites(event.position)
			if sprite != null:
				score_labels.multiplier += 1
				score_labels.letter_score += sprite.score
		elif event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			swap_sprite = gridGen.check_for_selected_sprites(event.position)
		elif event.button_index != MOUSE_BUTTON_RIGHT:
			pressed = false
			var add_to_cum = gridGen.pop_input()
			score_labels.reset(add_to_cum)
	elif event is InputEventMouseMotion and pressed:
		var sprite = gridGen.check_for_selected_sprites(event.position)
		if sprite != null:
			score_labels.multiplier *= 2
			score_labels.letter_score += sprite.score
		
	elif event is InputEventMouseMotion and swap_sprite != null:
		var next_sprite = gridGen.check_for_selected_sprites(event.position)
		if next_sprite != null and next_sprite.sprite != swap_sprite.sprite:
			gridGen.swap_sprites(swap_sprite, next_sprite)
			swap_sprite = null
