extends CharacterNPC
class_name SnakeNPC

func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# player controlled vs ai controlled
	if has_collided_with_player:
		player_controll(delta)
	else:
		ai_controll(delta)

func player_controll(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump / flap
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			flap_count = 0
			velocity.y = jump_velocity
		elif flap_count < max_flaps:
			velocity.y = -flap_force
			flap_count += 1
			
	# Handle head state
	if Input.is_action_just_pressed("look_up"):
		head = 'look_up'
	if Input.is_action_just_pressed("look_down"):
		head = 'look_down'
	if Input.is_action_just_released('look_up') or Input.is_action_just_released('look_down'):
		head = 'idle'

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			if head == "look_up":
				animated_sprite_2d.play('look_up')
			elif head == "look_down":
				animated_sprite_2d.play("look_down")
			else:
				animated_sprite_2d.play('idle')
		else:
			animated_sprite_2d.play("run")
	elif flap_count == 0:
		animated_sprite_2d.play("jump")
	else:
		animated_sprite_2d.play("flap")
	
		
	# Apply movement
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
func ai_controll(delta):
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

