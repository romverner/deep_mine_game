extends StaticBody2D

class_name colapsible_block

signal falling

@onready var texture_sprite = $TerrainTextureSprite
@onready var impact_area = $ImpactArea

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _starting_pos = null
var _last_known_pos = null
var _is_falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_starting_pos = global_position
	
func _snap_to_grid():
	var current_y = int(snappedf(position.y, 1.0))
	var new_y = current_y - (current_y % 16) + 8
	position.y = new_y
	
	# Saving last position for nebulous save-game feature at some point
	_last_known_pos = global_position

# Using built-in phsyics caused lag when too many stones on screen because 
# godot calcs physics every whether falling or no. So just imitate the physics 
# here only when actually falling. Tradeoff is falling velocity is constant
func _process(delta):
	if _is_falling:
		# Falling grav is less to give players a chance to react
		position.y += gravity * delta * 0.1

func _on_impact_area_body_entered(body):
	if body is Player and _is_falling:
		body.knockout()

# when block below disappears, assume this block should fall
func _on_down_block_area_body_exited(body):
	_is_falling = true
	texture_sprite.visible = false

# when block appears (if not player) assume block should stop falling
func _on_down_block_area_body_entered(body):
	if not body is Player:
		_is_falling = false
		# only snap to grid when done falling to prevent jitter
		_snap_to_grid()
		texture_sprite.visible = true
