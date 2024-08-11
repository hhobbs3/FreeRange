extends State
class_name StateNPCEnemy

@export var enemy: CharacterNPC
@onready var player = get_tree().get_first_node_in_group("player")
const StateNpcEnemyHelperFunctions = preload("res://scripts/states/enemy/state_npc_enemy_helper_functions.gd")
