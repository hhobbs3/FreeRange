extends CharacterNPC
class_name SnakeNPC
@onready var enemy_collision_horizontal_attack = $EnemyAreaHorizontalAttack/EnemyCollisionHorizontalAttack

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	# print(health)
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
		enemy_collision_horizontal_attack.position.x = 15
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
		enemy_collision_horizontal_attack.position.x = -15


func _on_hitbox_area_entered(area):
	take_damage(area, 1)

func take_damage(area, damage):
	if area.is_in_group('player_attack'):
		health -= damage
		hit = true
	if area.is_in_group('bullet'):
		health -= 5
		hit = true
