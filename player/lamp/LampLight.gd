extends PointLight2D

class_name LampLight

signal lamp_turned_off

func _on_lamp_fuel_change(fuel_amount, shut_off, _turn_on):
	if not shut_off:
		self.texture.width = fuel_amount
		self.texture.height = fuel_amount
	elif shut_off:
		# Cast everything to black to "turn off" the lamp.
		self.texture.gradient.colors = PackedColorArray(
			[Color(0, 0, 0, 0), Color(0, 0, 0, 0)]
		)
