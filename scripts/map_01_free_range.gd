extends Node2D
@export var character_to_kill : Character 
var enemy_scene = preload("res://scenes/spawn_enemy.tscn")
const CHARACTER_SNAKE = preload("res://scenes/character_snake.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randi_range(0, 20), -100)
	add_child(enemy)
