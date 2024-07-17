extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_levels.tscn")


func _on_upgrades_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	get_tree().quit()


func _on_quit_pressed():
	pass # Replace with function body.
