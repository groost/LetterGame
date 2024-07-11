extends Node

class TrieNode1:
	var children = {}
	var is_end_of_word = false

class Trie:
	var root = TrieNode1.new()
	
	func insert(word):
		var node = root
		for char in word:
			if not char in node.children:
				node.children[char] = TrieNode1.new()
			node = node.children[char]
		node.is_end_of_word = true
	
	func search(word):
		var node = root
		for char in word:
			if not char in node.children:
				return false
			node = node.children[char]
		return node.is_end_of_word
	
	func starts_with(prefix):
		var node = root
		for char in prefix:
			if not char in node.children:
				return false
			node = node.children[char]
		return true
