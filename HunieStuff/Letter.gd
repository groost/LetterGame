# LetterGenerator.gd
extends Sprite2D

class_name Letter

var is_special = ''
var letter = ''
var score = 0

# Define the weighted letter distribution based on English letter frequency
var letter_weights = {
	'A': 8.2, 'B': 1.5, 'C': 2.8, 'D': 4.3, 'E': 12.7, 'F': 2.2, 'G': 2.0, 
	'H': 6.1, 'I': 7.0, 'J': 0.2, 'K': 0.8, 'L': 4.0, 'M': 2.4, 'N': 6.7, 
	'O': 7.5, 'P': 1.9, 'Q': 0.1, 'R': 6.0, 'S': 6.3, 'T': 9.1, 'U': 2.8, 
	'V': 1.0, 'W': 2.4, 'X': 0.2, 'Y': 2.0, 'Z': 0.1
}

var scrabble_scores = {
	"A": 1, "B": 3, "C": 3, "D": 2, "E": 1, "F": 4, "G": 2,
	"H": 4, "I": 1, "J": 8, "K": 5, "L": 1, "M": 3, "N": 1,
	"O": 1, "P": 3, "Q": 10, "R": 1, "S": 1, "T": 1, "U": 1,
	"V": 4, "W": 4, "X": 8, "Y": 4, "Z": 10, "?": 0, "": 0
}

# Normalize the weights to sum to 1
func normalize_weights(weights):
	var total = 0.0
	for weight in weights.values():
		total += weight
	for key in weights.keys():
		weights[key] /= total
	return weights

var normalized_weights = normalize_weights(letter_weights)

func set_letter(let):
	letter = let
	score = scrabble_scores[letter]
	
# Function to generate a letter based on the weighted distribution
func generate_letter():
	var random_value = randf()
	var cumulative = 0.0
	var return_letter = 'E'
	
	for letter in normalized_weights.keys():
		cumulative += normalized_weights[letter]
		if random_value <= cumulative:
			return_letter = letter
			break
	
	var special_change = randf()
	if special_change > .95:
		is_special = 'wild'
		return_letter = '?'
		
	letter = return_letter
	score = scrabble_scores[letter]
