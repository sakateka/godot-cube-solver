extends Node3D

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

func _process(_delta: float) -> void:
	pass
