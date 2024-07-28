extends State
class_name StateNPCEnemy

@export var enemy: CharacterNPC

var player: CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_area_2d_area_entered(area):
	print('area')
	if area.is_in_group('player_attack'):
		take_damage(1)
		
func take_damage(damage):
	enemy.health -= damage
	if enemy.health <= 0:
		print('switch to die')
		Transitioned.emit(self, "Die")
