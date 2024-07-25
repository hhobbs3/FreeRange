extends State
class_name EnemyAttack

@export var enemy: CharacterNPC
@export var move_speed := 80.0
@onready var timer = $Timer

var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	#var direction = Vector2(player.global_position.x - enemy.global_position.x,0)
	#enemy.velocity.y = -100
	#enemy.velocity = direction.normalized() * move_speed
	print('attack')
	#timer.start()
	print('end attack')
	#if direction.length() > 120:
	print('switch to follow')
	Transitioned.emit(self, "Follow")
