extends State
class_name EnemyDie

@export var enemy: CharacterNPC
@export var move_speed := 10.0
@onready var collision_snake = $"../../CollisionShape2DSnake"
@onready var character_snake = $"../.."

var player: CharacterBody2D

var move_direction : Vector2
var wander_time : float

func stop_moving():
	move_direction = Vector2(0,0)
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	stop_moving()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else: 
		stop_moving()

func Physics_Update(delta: float):
	character_snake.health = 0
