extends Node2D
var enemy_scene = preload("res://scenes/characters/spawn_enemy.tscn")
var enemy_test = preload("res://scenes/characters/character_snake.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	pass
	'''
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randi_range(0, 20), -100)
	add_child(enemy)
	var enemy2 = enemy_test.instantiate()
	enemy2.position = Vector2(randi_range(0, 20), -100)
	add_child(enemy2)
	'''
