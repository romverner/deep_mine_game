extends Node2D

signal fuel_change

# LAMP SETTINGS
@export var lamp_fuel = 120 		# Denotes width of rendered mask.
@export var consumption_rate = 60 	# Frames to wait for before consuming (60 = 1 second)

var _lamp_is_on = true
var _lamp_consumption_ticker = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _lamp_consumption_ticker != consumption_rate:
		_lamp_consumption_ticker += 1
	else:
		_lamp_consumption_ticker = 1
		if _lamp_is_on:
			_consume_fuel()

func _consume_fuel():
	if lamp_fuel > 32:
		lamp_fuel -= 1
		fuel_change.emit(lamp_fuel, false, false)
	else:
		fuel_change.emit(lamp_fuel, true, false)

func _on_point_light_2d_lamp_turned_off():
	_lamp_is_on = false
