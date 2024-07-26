extends Node
class_name State

@export var enemy: CharacterNPC

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal Transitioned

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass

func _on_area_2d_area_entered(area):
	print('area')
	if area.is_in_group('hit'):
		take_damage(1)
		
func take_damage(damage):
	enemy.health -= damage
	if enemy.health <= 0:
		print('switch to die')
		Transitioned.emit(self, "Die")
