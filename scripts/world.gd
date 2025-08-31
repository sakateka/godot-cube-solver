extends Node3D

@export var cube: Node3D

const ROTATION_SPEED = 0.005
var rot: Vector2 = Vector2.ZERO


func _unhandled_input(event):
	#if event is InputEventScreenTouch:
	#	print("Touch event: ", event)
	if event is InputEventScreenDrag:
		var x = event.relative.x * ROTATION_SPEED
		var y = event.relative.y * ROTATION_SPEED
		
		# cube.transform.basis = Basis()
		cube.rotate_x(y)
		cube.rotate_y(x)
