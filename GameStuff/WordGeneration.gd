extends Node

var words = []
var possible_words = []
var possible_easy_words = []
var directions = [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]]
var trie = preload("res://GameStuff/TrieClasses.gd").new().Trie.new()

func generate_words():
	var file = FileAccess.open("res://common_words.txt", FileAccess.READ)
	words = file.get_as_text().split("\n")
	print(words)
	var actual_words = []
	
	for word in words:
		if word != '\n':
			trie.insert(word)
			actual_words.append(word)
			
	words = actual_words
	return words

func is_valid_word(word):
	if word in words:
		return true
		
	for possible_word in words:
		if match_with_wildcard(word, possible_word):
			print("possible word: " + possible_word)
			return true
	
	return false

func match_with_wildcard(word, possible_word):
	if len(word) != len(possible_word):
		return false
	
	for i in range(len(word)):
		if word[i] != '?' and word[i] != possible_word[i]:
			return false
			
	return true

func dfs(x, y, node, path, grid, visited):
	#print(str(x) + " " + str(y))
	if node.is_end_of_word and not path in possible_words:
		possible_words.append(path)
	if x < 0 or x >= grid.size() or y < 0 or y >= grid[0].size() or visited[x][y]:
		return
	var char = grid[x][y].letter.to_lower()
	if not char in node.children and char != '?':
		#print(char)
		return
	visited[x][y] = true
	if char == '?':
		for c in node.children.keys():
			for direction in directions:
				dfs(x + direction[0], y + direction[1], node.children[c], path + c, grid, visited)
	else:
		for direction in directions:
			dfs(x + direction[0], y + direction[1], node.children[char], path + char, grid, visited)
	visited[x][y] = false
	
func bruteforce(r, c, grid):
	var return_words = []
	for dir in directions:
		var node = trie.root
		var path = grid[r][c].letter.to_lower()
		var temp_r = r
		var temp_c = c
		
		while (temp_r + dir[0] < len(grid) and temp_r + dir[0] >= 0) and (temp_c + dir[1] < len(grid[0]) and temp_c + dir[1] >= 0):
			if node.is_end_of_word:
				return_words.append(path)
			
			temp_r += dir[0]
			temp_c += dir[1]
			
			var char = grid[temp_r][temp_c].letter.to_lower()
			if not char in node.children:
				break
				
			node = node.children[char]
			path += char
	
	return return_words

func dfs1():
	print(trie.search("hello"))
	
func find_words_with_bruteforce(grid):
	var return_words = []
	
	for r in len(grid):
		for c in len(grid[r]):
			return_words.append_array(bruteforce(r, c, grid))
			
	return return_words
	
func find_words(grid):
	possible_words = []
	var visited = []
	for i in range(grid.size()):
		visited.append([])
		for j in range(grid[0].size()):
			visited[i].append(false)
	
	
	for i in range(grid.size()):
		for j in range(grid[i].size()):
			print("i/j: " + str(i) + " " + str(j))
			dfs(i, j, trie.root, "", grid, visited)
	
	return possible_words

func find_easy_words(grid):
	var directions = [
		Vector2(1, 0),  # Right
		Vector2(0, 1),  # Down
		Vector2(1, 1),  # Down-right (Diagonal)
		Vector2(-1, 1)  # Down-left (Diagonal)
	]
	
	for x in range(grid.size()):
		for y in range(grid[0].size()):
			for direction in directions:
				find_words_in_direction(x, y, direction, grid)

	return possible_easy_words
	
func find_words_in_direction(x, y, direction, grid):
	var word = ""
	var node = trie.root
	var i = 0
	
	while is_within_bounds(x + i * direction.x, y + i * direction.y, grid):
		var char = grid[x + i * direction.x][y + i * direction.y].letter.to_lower()
		
		if not char in node.children:
			break
		
		node = node.children[char]
		word += char
		#print(word)
		if node.is_end_of_word:
			possible_easy_words.append(word)
		
		i += 1

func is_within_bounds(x, y, grid):
	return x >= 0 and x < grid.size() and y >= 0 and y < grid[0].size()
