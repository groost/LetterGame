extends Control

# Reference to the ArrowButton and ItemGrid
@onready var arrow_button = $ArrowButton
@onready var item_grid = $ItemGrid

# Function to toggle the visibility of the ItemGrid
func _on_ArrowButton_pressed():
	item_grid.visible = !item_grid.visible

func _ready():
	# Position the dropdown at the top right of the screen
	var viewport_size = get_viewport().size
	custom_minimum_size = Vector2(viewport_size.x, custom_minimum_size.y)
	arrow_button.position = Vector2(viewport_size.x - arrow_button.custom_minimum_size.x, 0)
	item_grid.position = Vector2(viewport_size.x - item_grid.custom_minimum_size.x, arrow_button.custom_minimum_size.y)
