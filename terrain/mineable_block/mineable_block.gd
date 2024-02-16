extends Node2D

class_name MineableBlock

signal depleted

@export var RESOURCE_POOL = [
	load('res://inventory/resources/copper.tres'),
]

@export var TEXTURE_ASSETS = [
	'res://art/Terrain/Dirt 1.png',
	'res://art/Terrain/Dirt 2.png',
	'res://art/Terrain/Dirt 3.png',
	'res://art/Terrain/Dirt 4.png'
]

@export var hitpoints : int = 100
@export var resource: InventoryItem

@onready var texture_sprite = $TextureSprite
@onready var resource_sprite = $ResourceSprite

func _ready():
	var texture = TEXTURE_ASSETS.pick_random()
	resource = RESOURCE_POOL.pick_random()
	
	if resource:
		texture_sprite.texture = load(texture)
		resource_sprite.texture = resource.texture
		resource_sprite.visible = true

# Mine this block for its resource if any.
func deplete(hit_value):
	hitpoints -= hit_value
	if hitpoints <= 0:
		depleted.emit(resource)
		queue_free()
