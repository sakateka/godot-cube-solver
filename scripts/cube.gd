class_name Cube
extends Node3D

const PI_2 = PI / 2
const POSITION_META = "origin_position"

var layer: Node3D
var target_angle: float = 0.0
var rotation_speed = 2
var in_rotation: bool = false

var faceScene: PackedScene = preload("res://scenes/face.tscn")
var cubieScene: PackedScene = preload("res://scenes/cubie.tscn")

func _ready() -> void:
	for i in range(10, -1, -1):
		print("I = ", i)
		
	$CubieRoot.set_meta(POSITION_META, $CubieRoot.position)
	for x in [-1.1, 0, 1.1]:
		for y in [-1.1, 0, 1.1]:
			for z in [-1.1, 0, 1.1]:
				var pos = Vector3(x, y, z)
				if position == pos:
					continue  # skip root cube
				
				var n: MeshInstance3D = cubieScene.instantiate()
				n.position = pos
				n.set_meta(POSITION_META, pos)
				spawn_faces(n)
				add_child(n)
	G.cube = self

#
# Facelet management
#

static func position_to_index_in_group(direction: Vector3, cubie_pos: Vector3) -> int:
	var grid_x: int
	var grid_y: int
	# Cubie indices
	#                                 
	#                             x -z   UP
	#                           (-1 -1) ( 0 -1) ( 1 -1)
	#                           (-1  0) ( 0  0) ( 1  0)
	#                           (-1  1) ( 0  1) ( 1  1) 
	#   z   y   LEFT              x  y   FRONT            -z  y    RIGHT           -x  y  BACK
	#  (-1  1) ( 0  1) ( 1  1)  (-1  1) ( 0  1) ( 1  1)  ( 1  1) ( 0  1) (-1  1)  ( 1  1) ( 0  1) (-1  1)
	#  (-1  0) ( 0  0) ( 1  0)  (-1  0) ( 0  0) ( 1  0)  ( 1  0) ( 0  0) (-1  0)  ( 1  0) ( 0  0) (-1  0)
	#  (-1 -1) ( 0 -1) ( 1 -1)  (-1 -1) ( 0 -1) ( 1 -1)  ( 1 -1) ( 0 -1) (-1 -1)  ( 1 -1) ( 0 -1) (-1 -1)
	#                             x  z   DOWN
	#                           (-1  1) ( 0  1) ( 1  1)
	#                           (-1  0) ( 0  0) ( 1  0)
	#                           (-1 -1) ( 0 -1) ( 1 -1)
	direction = Vector3(direction.x as int, direction.y as int, direction.z as int)
	match direction:
		Vector3.UP:
			grid_x = cubie_pos.x as int
			grid_y = -cubie_pos.z as int
		Vector3.DOWN:
			grid_x = cubie_pos.x as int
			grid_y = cubie_pos.z as int
		Vector3.LEFT:
			grid_x = cubie_pos.z as int
			grid_y = cubie_pos.y as int
		Vector3.RIGHT:
			grid_x = -cubie_pos.z as int
			grid_y = cubie_pos.y as int
		Vector3.BACK: # Actually front
			grid_x = cubie_pos.x as int
			grid_y = cubie_pos.y as int
		Vector3.FORWARD: # Actually back
			grid_x = -cubie_pos.x as int 
			grid_y = cubie_pos.y as int
		_:
			push_error("unreachable direction=", direction)

	# Grid
	# 0 1 2     (-1  1) ( 0  1) ( 1  1)
	# 3 4 5  => (-1  0) ( 0  0) ( 1  0)
	# 6 7 8     (-1 -1) ( 0 -1) ( 1 -1)
	grid_x = grid_x + 1
	grid_y = -grid_y + 1
	
	var idx = grid_y * 3 + grid_x
	return idx

func spawn_faces(n: MeshInstance3D):
	var pos = n.position;	
	spawn_face(n, Vector3(pos.x, 0, 0))
	spawn_face(n, Vector3(0, pos.y, 0))
	spawn_face(n, Vector3(0, 0, pos.z))

func spawn_face(n: MeshInstance3D, direction: Vector3):
	if direction == Vector3.ZERO:
		return
		
	var face = faceScene.instantiate()
	face.for_direction(direction)
	
	n.add_child(face)

func get_facelet() -> String:

	var facelet_str: Array[String]
	facelet_str.resize(54)
	facelet_str.fill(".")
	
	for cubie in get_children():
		for face in cubie.get_children():
			if face is Face:
				var real_face_pos: Vector3 =  cubie.transform.basis * face.position
				var index = Face.position_to_index(cubie.position, real_face_pos)

				var color: Color = face.get_color()
				facelet_str[index] = G.color_manager.color_to_facelet_letter(color)
		
	return "".join(facelet_str)

#
#  Layer Rotation
#
func is_rotating() -> bool:
	return in_rotation

func _physics_process(delta):
	if not in_rotation:
		return
		
	layer.rotation.x += delta * rotation_speed
	if layer.rotation.x >= target_angle:
		print("Rotation completed")
		layer.rotation.x = target_angle
		in_rotation = false
		
		# Reparent layers children to root node
		for node in layer.get_children():
			node.reparent(self)
		$CubieRoot.remove_child(layer)
		layer.free()

func rotate_layer(move: String):
	if in_rotation:
		return
		
	print("Apply rotation: ", move)

	in_rotation = true
	
	layer = Node3D.new()
	layer.position = Vector3(1.1, 0, 0)
	$CubieRoot.add_child(layer)

	for node in get_children():
		if node.position.dot(Vector3.RIGHT) > 1.0:
			node.reparent(layer)

	target_angle = layer.rotation.x + PI_2

func reset_cubie_rotations() -> void:
	for cubie in get_children():
		for face in cubie.get_children():
			if face is Face:
				face.rotation = Vector3.ZERO
		cubie.rotation = Vector3.ZERO
		cubie.position = cubie.get_meta(POSITION_META) as Vector3


func clear_colors():
	for cubie in get_children():
		for face in cubie.get_children():
			if face is Face:
				face.clear_color()
	G.color_manager.mark_all_colors_as_unused()

func fix_colors():
	reset_cubie_rotations()
	for cubie in get_children():
		for face in cubie.get_children():
			if face is Face:
				face.reset_color()
	G.color_manager.mark_all_colors_as_used()
