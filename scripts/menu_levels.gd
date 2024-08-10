extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_demo_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/game.tscn")


func _on_free_range_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/map_01_free_range.tscn")


func _on_procedural_map_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/map_procedural_terrain.tscn")


func _on_gun_pressed():
		get_tree().change_scene_to_file("res://scenes/maps/sandbox.tscn")
