extends StatePlayer
class_name PlayerLanding
@export var landing_animation_name : String = "landing"
func Enter():
	pass
	
func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	if player.current_health <= 0:
			Transitioned.emit(self, "Die")
	
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == landing_animation_name:
		Transitioned.emit(self, 'Ground')
