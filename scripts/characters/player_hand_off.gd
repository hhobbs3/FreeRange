extends Hands2D
class_name OffHandPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weapons : Array[Node] = get_children()
	hand_attack(weapons, 'hand_off')

