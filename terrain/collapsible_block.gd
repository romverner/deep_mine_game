extends RigidBody2D

class_name colapsible_block

signal falling

@onready var texture_sprite = $TerrainTextureSprite
@onready var impact_area = $ImpactArea

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _starting_pos = null
var _is_falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_starting_pos = global_position
	#freeze = true

func _on_impact_area_body_exited(body):
	if !(body is Player):
		freeze = false
		falling.emit()

func _on_impact_area_body_entered(body):
	if body is Player:
		body.knockout()
	else:
		# On freeze, re-snap x-axis
		position.x = int(self.position.x) - (int(self.position.x) % 16) + 8
		freeze = true

func _on_falling():
	freeze = false

func _on_down_detection_area_area_entered(area):
	if area is UpDetectionArea:
		freeze = true
