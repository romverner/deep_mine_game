extends Node2D

class_name MineableBlock

signal depleted

@export var RESOURCE_POOL = ['copper', 'empty',]
@export var RESOURCE_ASSETS = {
	'copper': load("res://art/Resources/copper.png"),
}
@export var hitpoints : int = 100
@export var resource = ''
@onready var resource_sprite = $ResourceSprite

func _ready():
	resource = RESOURCE_POOL.pick_random()
	
	if resource != 'empty':
		resource_sprite.texture = RESOURCE_ASSETS[resource]
		resource_sprite.visible = true

# Mine this block for its resource if any.
func deplete(hit_value):
	hitpoints -= hit_value
	if hitpoints <= 0:
		depleted.emit(resource)
		queue_free()
