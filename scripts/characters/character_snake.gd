extends CharacterNPC
class_name SnakeNPC

func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		print('v ' + str(velocity.y))
		
	move_and_slide()
	if velocity.length() > 0:
		animated_sprite_2d.play("run")
	if velocity.length() == 0:
		animated_sprite_2d.play("idle")
	
	if health == 0:
		animated_sprite_2d.play("die")
		
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
		
func _on_area_2d_area_entered(area):
	print('area1A')
	print(area.get_groups())
	if area.is_in_group('hit'):
		health -= 1

func _on_area_2d_body_entered(body):
	print('body1A')
	print(body.get_groups())
	if body.is_in_group('Player'):
		health -= 1

