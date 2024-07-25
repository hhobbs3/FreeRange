extends Area2D

func _process(_delta):
	position.y += 1


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
