extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	pass


func _on_demo_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/game.tscn")


func _on_free_range_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/map_01_free_range.tscn")


func _on_procedural_map_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/map_procedural_terrain.tscn")


func _on_gun_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/maps/sandbox.tscn")


func _on_terrain_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/map_02_noise_terrain.tscn")


func _on_simple_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/map_03_simplified.tscn")


func _on_visual_test_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/map_04_visual.tscn")
