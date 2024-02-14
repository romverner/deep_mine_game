extends TileMap

signal block_depleted

@export var TILE_SCENES = {
	0: preload('res://terrain/mineable_block.tscn'),
	1: preload('res://terrain/collapsible_block.tscn'),
}

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
	print(resource)
	block_depleted.emit(resource)
