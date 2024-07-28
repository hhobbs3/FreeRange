extends Node

@export var initial_state : State

var current_state: State
var states: Dictionary = {}

# sets up the initial states, runs once
func _ready():
	# hook up states from children nodes
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	# set up initial state
	if initial_state:
		current_state = initial_state
		initial_state.Enter()
		

func _process(delta):
	if current_state:
		current_state.Update(delta)
	
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
		
func on_child_transition(state, new_state_name):
	# if the passed in state doesn't match the current state, return
	if state != current_state:
		return
	
	# set new state, return if it doesn't work
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	# exit current state
	if current_state:
		current_state.Exit()
	# start new state and set as current state
	new_state.Enter()
	current_state = new_state
