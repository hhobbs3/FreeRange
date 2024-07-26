extends CharacterNPC
class_name SnakeNPC

func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()
	if velocity.length() > 0:
		animated_sprite_2d.play("run")
	if velocity.length() == 0:
		animated_sprite_2d.play("idle")
	print('health = ' + str(health))
	if health <= 0:
		animated_sprite_2d.play("die")
		
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
