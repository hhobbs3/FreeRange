extends CharacterNPC
class_name SnakeNPC
@onready var enemy_collision_horizontal_attack = $EnemyAreaHorizontalAttack/EnemyCollisionHorizontalAttack

func _physics_process(delta):
	move_and_slide()
	print(health)
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
		enemy_collision_horizontal_attack.position.x = 15
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
		enemy_collision_horizontal_attack.position.x = -15
