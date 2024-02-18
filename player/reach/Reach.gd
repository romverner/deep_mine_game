extends Node2D

signal up_block_disappeared

# Node is only here to track reachable bodies, which are accessed by player.
var right_bodies = []
var left_bodies = []
var down_bodies = []
var up_bodies = []

# Standardizing tracking of reachable bodies, should only really be 1.
func _track_reachable_body(body, storage_array, removing = false):
	if body in storage_array and removing:
		storage_array.erase(body)
		return
	if body not in storage_array and not removing:
		storage_array.append(body)
		return

func _on_right_reachable_area_body_entered(body):
	if body is MineableBlock:
		_track_reachable_body(body, right_bodies)

func _on_right_reachable_area_body_exited(body):
	if body is MineableBlock:
		_track_reachable_body(body, right_bodies, true)

func _on_down_reachable_area_body_entered(body):
	if body is MineableBlock:
		_track_reachable_body(body, down_bodies)

func _on_down_reachable_area_body_exited(body):
	if body is MineableBlock:
		_track_reachable_body(body, down_bodies, true)

func _on_left_reachable_area_body_entered(body):
	if body is MineableBlock:
		_track_reachable_body(body, left_bodies)

func _on_left_reachable_area_body_exited(body):
	if body is MineableBlock:
		_track_reachable_body(body, left_bodies, true)

func _on_up_reachable_area_body_entered(body):
	if body is MineableBlock:
		_track_reachable_body(body, up_bodies)

func _on_up_reachable_area_body_exited(body):
	if body is MineableBlock:
		up_block_disappeared.emit()
		_track_reachable_body(body, up_bodies, true)
