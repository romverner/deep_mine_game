extends Node2D

@onready var _chain = $GrapplingHookChain

func _input(event):
	# Just ensuring raycast is always looking up. The -50 is abritrary. It's just "above" player
	var reachable_height = Vector2(global_position)
	reachable_height.y -= 50
	if event.is_action_pressed('grapple'):
		look_at(reachable_height)
