extends TileMap

class_name DepthTileMap

signal block_depleted

@export var TILE_SCENES = {
	0: preload('res://terrain/mineable_block/mineable_block.tscn'),
	1: preload('res://terrain/collapsible_block/collapsible_block.tscn'),
}

var _player = null

func _ready():
	_replace_tiles_with_scenes()

func _process(_delta):
	pass

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = TILE_SCENES):
	# Iterating through all cells in first layer.
	for dirt_tile in get_used_cells(0):
		# Grabbing cell's source ID.
		var tile_id = get_cell_source_id(0, dirt_tile)
		
		# Matching it to custom dictionary that holds scene to swap in.
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]
			_replace_tile_with_object(dirt_tile, object_scene)
		

func _replace_tile_with_object(tile_pos: Vector2, object_scene: PackedScene, _parent: Node = get_tree().current_scene):
	# Double checking tile has tileset value and if so removing it.
	if get_cell_source_id(0, tile_pos) != -1:
		set_cell(0, tile_pos, -1)
	
	# Adding supplied scene to all removed tiles.
	if object_scene:
		var obj = object_scene.instantiate()
		var obj_pos = map_to_local(tile_pos)
		obj.position = obj_pos
		obj.connect("depleted", _on_mineable_block_depleted)
		add_child(obj)

func _on_mineable_block_depleted(resource):
	block_depleted.emit(resource)

# We want ladders to be children of tilemap so we can save them to level on exit
func _on_depth_item_placement_received(item):
	# Some actions are limited to the depths, so action logic located here.
	if _player:
		var item_scene = item.instantiate()
		
		# map player global pos to tile indices
		# then find global pos of given tile
		var tile_index = map_to_local(_player.position)
		var item_position = local_to_map(tile_index)
		
		# next snap to 16x16 grid
		var x_pos = item_position.x
		var y_pos = item_position.y
		x_pos = x_pos - (x_pos % 16)
		y_pos = y_pos - (y_pos % 16)
		item_scene.position = Vector2(x_pos, y_pos)
		add_child(item_scene)

func _on_area_2d_body_entered(body):
	if body is Player:
		_player = body

func _on_area_2d_body_exited(body):
	if body is Player:
		_player = null


func _on_depth_player_shot_grapple(blocks_reachable):
	# Some actions are limited to the depths, so action logic located here.
	if _player:
		var tile_index = map_to_local(_player.position)
		var item_position = local_to_map(tile_index)
		var x_pos = item_position.x
		var y_pos = item_position.y
		
		x_pos = x_pos - (x_pos % 16)
		# Subtract 16 to get tile above player.
		item_position.y = item_position.y - (item_position.y % 16) - 16
		
		var cell_data = get_cell_tile_data(0, item_position)
		print(cell_data)
