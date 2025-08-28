class_name Cube
extends Node3D

const PI_2 = PI / 2

var layer: Node3D
var target_angle: float = 0.0
var rotation_speed = 2
var in_rotation: bool = false

var faceScene: PackedScene = preload("res://scenes/face.tscn")
var face_idx: int = 0

func _ready() -> void:	
	for x in [-1.1, 0, 1.1]:
		for y in [-1.1, 0, 1.1]:
			for z in [-1.1, 0, 1.1]:
				var pos = Vector3(x, y, z)
				if position == pos:
					continue  # skip root cube
				
				var n: MeshInstance3D = $CubieRoot.duplicate()
				n.position = pos
				spawn_faces(n)
				add_child(n)

func _physics_process(delta):
	if not in_rotation:
		return
		
	layer.rotation.x += delta * rotation_speed
	if layer.rotation.x >= target_angle:
		print("Rotation completed")
		layer.rotation.x = target_angle
		in_rotation = false
		
		var cube: Node3D = get_node("/root/World/Cube")
		for node in layer.get_children():
			node.reparent(cube)
		cube.remove_child(layer)
		layer.free()

func is_rotating() -> bool:
	return in_rotation

func spawn_faces(n: MeshInstance3D):
	var pos = n.position;
	var type: Globals.CubieType = int(pos.abs().dot(Vector3.ONE)) as Globals.CubieType
	
	spawn_face(n, Vector3(pos.x, 0, 0), type)
	spawn_face(n, Vector3(0, pos.y, 0), type)
	spawn_face(n, Vector3(0, 0, pos.z), type)

func spawn_face(n: MeshInstance3D, direction: Vector3, type: Globals.CubieType):
	if direction == Vector3.ZERO:
		return
		
	var face = faceScene.instantiate()
	face.facelet_idx = face_idx;
	face_idx += 1
	face.for_direction(direction, type)
	
	n.add_child(face)

func rotate_layer(rotation: String):
	if in_rotation:
		return
		
	in_rotation = true
	var root: Node3D = get_node("/root/World/Cube/CubieRoot")
	
	var cubies: Array[Node] = get_children()
	layer = Node3D.new()
	layer.position = Vector3(1.1, 0, 0)
	root.add_child(layer)
	
	for node in cubies:
		print("dot direction node.pos=", node.position, " right: ", node.position.dot(Vector3.RIGHT))
		print("dot direction middle: ", node.position.abs().dot(Vector3(1, 0, 1)))
		if node.position.x > 1.0:
			print("right cubie: ", node.position)
			node.reparent(layer)

	target_angle = layer.rotation.x + PI_2
	print("rotate to: ", target_angle)
