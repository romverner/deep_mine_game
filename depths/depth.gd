extends Node2D

signal level_resource_depleted
signal item_placement_received
signal player_shot_grapple

func _on_level_block_depleted(resource):
	level_resource_depleted.emit(resource)

func _on_player_place_item(item):
	item_placement_received.emit(item)

func _on_player_shoot_grapple(reachable_height):
	player_shot_grapple.emit(reachable_height)
