extends Node2D
@export var character_to_kill : Character 

# Called when the node enters the scene tree for the first time.
func _ready():
	character_to_kill.die()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
