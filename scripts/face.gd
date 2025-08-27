class_name Face extends Area3D


var color: Color
@export var cubie_type: Globals.CubieType
@export var facelet_idx: int = -1

func for_direction(direction: Vector3, type: Globals.CubieType):
	var shapeInstance = get_child(0)
	var meshInstance = get_child(-1)
	
	meshInstance.mesh.size = (Vector3(0.95, 0.95, 0.95) - direction.normalized().abs()).abs()
	shapeInstance.shape.size = meshInstance.mesh.size
	meshInstance.mesh.material.albedo_color = Color.BLACK

	position = direction * 0.45


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		var parent: MeshInstance3D = get_parent()
		print("Input touch ", event.pressed ," on ", facelet_idx," with pos=", position, " for: ", parent.position)
	elif event is InputEventScreenDrag:
		print("Input drag on ", facelet_idx, " : ", event)
