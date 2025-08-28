class_name Face extends Area3D


var color: Color
@export var cubie_type: Globals.CubieType
@export var facelet_idx: int = -1

func for_direction(direction: Vector3, type: Globals.CubieType):
	var shapeInstance = get_child(0)
	var meshInstance = get_child(-1)
	
	meshInstance.mesh.size = (Vector3(0.90, 0.90, 0.90) - direction.normalized().abs()).abs()
	shapeInstance.shape.size = meshInstance.mesh.size
	
	match direction.normalized():
		Vector3.UP:
			meshInstance.mesh.material.albedo_color = G.white
		Vector3.RIGHT:
			meshInstance.mesh.material.albedo_color = G.red
		Vector3.BACK:
			meshInstance.mesh.material.albedo_color = G.blue
		Vector3.DOWN:
			meshInstance.mesh.material.albedo_color = G.yellow
		Vector3.LEFT:
			meshInstance.mesh.material.albedo_color = G.green
		Vector3.FORWARD:
			meshInstance.mesh.material.albedo_color = G.orange
	position = direction * 0.42


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		var parent: MeshInstance3D = get_parent()
		print("Input touch ", event.pressed ," on ", facelet_idx," with pos=", position, " for: ", parent.position)
	elif event is InputEventScreenDrag:
		print("Input drag on ", facelet_idx, " : ", event)
