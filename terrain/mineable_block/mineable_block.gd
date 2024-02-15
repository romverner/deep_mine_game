extends Node2D

class_name MineableBlock

signal depleted

@export var RESOURCE_POOL = ['copper', 'empty',]
@export var RESOURCE_ASSETS = {
	'copper': "res://art/Resources/copper.png",
}

@export var TEXTURE_ASSETS = [
	'res://art/Terrain/Dirt 1.png',
	'res://art/Terrain/Dirt 2.png',
	'res://art/Terrain/Dirt 3.png',
	'res://art/Terrain/Dirt 4.png'
]

@export var hitpoints : int = 100
@export var resource = ''

@onready var texture_sprite = $TextureSprite
@onready var resource_sprite = $ResourceSprite

func _ready():
	var texture = TEXTURE_ASSETS.pick_random()
	resource = RESOURCE_POOL.pick_random()
	
	if resource != 'empty':
		texture_sprite.texture = load(texture)
		resource_sprite.texture = load(RESOURCE_ASSETS[resource])
		resource_sprite.visible = true

# Mine this block for its resource if any.
func deplete(hit_value):
	hitpoints -= hit_value
	if hitpoints <= 0:
		depleted.emit(resource)
		queue_free()
