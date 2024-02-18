extends Node2D


func _input(event):
	if event.is_action_pressed('grapple'):
		look_at(get_global_mouse_position())
