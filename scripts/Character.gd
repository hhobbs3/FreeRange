class_name Character

extends Node2D

@export var species : String
@export var health : int
@export var jump_power : int
@export var flap_power : int # value 0 to x that determines flap power
@export var num_flaps : int
@export var speed : int # how fast they can move
@export var opacity : float # how visible they are by default (?)
@export var can_touch : bool # if touching kills
@export var can_attack : bool


func die():
	health = 0
	print(species + ' died.')
