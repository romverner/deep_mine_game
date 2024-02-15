extends Area2D

class_name PlayerBody

var climbing_ladder = false
var overlapping_ladders = []
var overlapping_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Ladder Body Detection
func _on_area_entered(area):
	if area is LadderArea:
		print(area)
		overlapping_ladders.append(area)
		climbing_ladder = len(overlapping_ladders) > 0

# Ladder Body Detection
func _on_area_exited(area):
	print(area)
	if area is LadderArea:
		print(area)
		overlapping_ladders.erase(area)
		climbing_ladder = len(overlapping_ladders) > 0



func _on_body_entered(body):
	print(body)
