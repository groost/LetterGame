extends GridContainer

var multiplier = 0
var letter_score = 0
var cum_score = 0
var mult_label = Label.new()
var score_label = Label.new()
var cum_label = Label.new()

func _process(delta):
	score_label.text = str(letter_score) + " Letter"
	mult_label.text = str(multiplier) + " Mult"
	cum_label.text = str(cum_score) + " Total"
	
func _init(grid):
	mult_label.custom_minimum_size = Vector2(50, 50)
	score_label.custom_minimum_size = Vector2(50, 50)
	cum_label.custom_minimum_size = Vector2(50, 50)
	
	position = Vector2(grid.CELL_SIZE.x * (grid.GRID_SIZE + 1), grid.CELL_SIZE.y)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(score_label)
	add_child(mult_label)
	add_child(cum_label)

func reset(add_to_cum):
	if add_to_cum:
		cum_score += multiplier * letter_score
	multiplier = 0
	letter_score = 0
