extends CharacterBody2D

class_name Player

@export var speed = 60
@export var inventory_space = 15
@export var pickaxe_level = 1

@onready var _animated_sprite = $AnimatedPlayerSprite
@onready var _reach = $Reach

const JUMP_VELOCITY = -205.0
const MINING_TIME = 1.0 # seconds

# Default last direction on init to right, since that's where players go from HUB
var last_direction_faced = 1

# Simple inventory tracking dict
var inventory = {
	'resources': [],
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	_animated_sprite.play('idle')

# Use this for animations and non-physics related controls.
func _process(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	var aiming_down = Input.is_action_pressed('down')
	var mining = Input.is_action_pressed('mine')
	
	# Just keeping track of direction player is facing.
	_animated_sprite.flip_h = direction < 0
	
	if mining and is_on_floor() and !(
		# Don't want sliding left/right while down-mining. Everything else ok.
		Input.is_action_pressed('down') and direction != 0
		) and !(direction):
		_handle_mining_actions(aiming_down)
	elif direction != 0:
		_animated_sprite.play('walk')
	else:
		_animated_sprite.play('idle')
	
# Trying to keep this physics only for real.
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		last_direction_faced = direction
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _mine_block(storage_array):
	if len(storage_array) > 0:
		var mineable_block = storage_array[0]
		if is_instance_valid(mineable_block):
				mineable_block.deplete(1 * MINING_TIME)

# Keeping mining actions to one place.
func _handle_mining_actions(aiming_down: bool):
	# Animations
	if aiming_down:
		_animated_sprite.play('mine-down')
	else:
		if last_direction_faced < 0:
			_animated_sprite.flip_h = true
			_animated_sprite.play('mine-side')
		else:
			_animated_sprite.flip_h = false
			_animated_sprite.play('mine-side')
	
	# Actions
	# Down
	if aiming_down:
		_mine_block(_reach.down_bodies)
	# Left
	elif last_direction_faced < 0:
		_mine_block(_reach.left_bodies)
	# Right
	else:
		_mine_block(_reach.right_bodies)

func _on_depth_level_resource_depleted(resource):
	if len(inventory['resources']) > inventory_space:
		print('out of space in inventory')
		return
		
	if resource != 'empty':
		inventory['resources'].append(resource)
	
	print(inventory)

# Standard player knockout function. Emptys inventory and respawns.
func knockout():
	inventory['resources'] = []
	self.global_position.x = 0
	self.global_position.y = 0
