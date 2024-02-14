extends RigidBody2D

class_name colapsible_block

var _starting_pos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.freeze = true
	_starting_pos = self.global_position
	
# We need to keep this block glued to its original x-axis position.
func _integrate_forces(state):
	# xform keeps track of point of origin from last frame.
	var xform = state.get_transform()
	
	# Here we keep this stone block glued horizontally in place.
	xform.origin.x = _starting_pos.x
	
	# Here we snap the block to full numbers to keep in line w/ pixel grid.
	xform.origin.y = snappedf(xform.origin.y, 1.0)
	state.set_transform(xform)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.linear_velocity.y == 0:
		$TerrainTextureSprite.visible = true

func _on_impact_area_body_exited(body):
	if body is MineableBlock:
		self.freeze = false
		$TerrainTextureSprite.visible = false

func _on_impact_area_body_entered(body):
	if body is MineableBlock:
		self.freeze = true
		$TerrainTextureSprite.visible = true
	elif body is Player:
		body.knockout()
