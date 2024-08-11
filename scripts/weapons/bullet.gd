extends RigidBody2D
var explosion = preload('res://scenes/weapons/explosion.tscn')

func _on_body_entered(body):
	if !body.is_in_group("player"):
		var explosion_instance = explosion.instantiate()
		explosion_instance.position = global_position
		
		get_parent().add_sibling(explosion_instance)
		queue_free()
