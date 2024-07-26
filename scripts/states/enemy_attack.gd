extends State
class_name EnemyAttack

@export var enemy: CharacterNPC
@export var move_speed := 80.0
@onready var timer = $Timer

var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	if timer.time_left > 0:
		pass
	else:
		var direction = Vector2(0,0)
		#enemy.velocity.y = -100
		enemy.velocity = direction.normalized() * move_speed
		print('attack')
		timer.start(1)

func _on_timer_timeout():
	print('end attack')
	print('switch to follow')
	Transitioned.emit(self, "Follow")
	
func _on_area_2d_area_entered(area):
	print('area2')
	if area.is_in_group('hit'):
		take_damage(1)


func _on_area_2d_body_entered(body):
	print('body2')
	if body.is_in_group('Player'):
		take_damage(1)
		
func take_damage(damage):
	enemy.health -= damage
	if enemy.health <= 0:
		print('switch to die')
		Transitioned.emit(self, "Die")
