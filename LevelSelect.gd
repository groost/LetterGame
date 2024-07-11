extends Control

var new_scene = load("res://HunieStuff/Main.tscn").instantiate()

func _on_level_1_pressed():
	new_scene.set_parameters(5)
	
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene


func _on_level_2_pressed():
	new_scene.set_parameters(7)
	
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene



func _on_level_3_pressed():
	new_scene.set_parameters(9)
	
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene


func _on_level_4_pressed():
	new_scene.set_parameters(11)
	
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
