extends RigidBody2D
var explosion = preload('res://scenes/weapons/explosion.tscn')

func _on_body_entered(body):
	# print(body)
	if !body.is_in_group("player"):
		# explosion isn't working well for me right now, maybe shift
		# to animation player rather than queue free?
		'''var explosion_instance = explosion.instantiate()
		explosion_instance.position = position
		get_parent().add_sibling(explosion_instance)'''
		
		queue_free()
