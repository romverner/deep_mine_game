extends Node2D

signal level_resource_depleted

func _on_level_block_depleted(resource):
	level_resource_depleted.emit(resource)
