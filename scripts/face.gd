class_name Face extends Area3D

const POSITION_MULTIPLIER = 0.42
const DIMENSION_SIZE = 0.90
const FACES_IN_GROUP = 9

const face_directions: Array[Vector3] = [
	Vector3.UP, 
	Vector3.RIGHT, 
	Vector3.BACK, # Actually front
	Vector3.DOWN,
	Vector3.LEFT,
	Vector3.FORWARD, # Actually back
]

enum EventType {
	TOUCH,
	DRAG,
}

var last_event: EventType

static func position_to_index(cubie_pos: Vector3, face_pos: Vector3) -> int:
	var direction = face_pos / POSITION_MULTIPLIER
	var group_idx: int = direction_to_group_index(direction)
	var face_idx: int = Cube.position_to_index_in_group(direction, cubie_pos)
	var index: int = group_idx * FACES_IN_GROUP + face_idx
	return index

static func direction_to_group_index(direction: Vector3) -> int:
	direction = direction.normalized()
	direction = Vector3(direction.x as int, direction.y as int, direction.z as int)
	var index: int = face_directions.find(direction)
	if index == -1:
		push_error("unreachable case for direction: ", direction.normalized())
	return index

func for_direction(direction: Vector3):
	var mesh: BoxMesh = $Mesh.mesh
	mesh.size = (Vector3(DIMENSION_SIZE, DIMENSION_SIZE, DIMENSION_SIZE) - direction.normalized().abs()).abs()
	$Shape.shape.size = mesh.size
	mesh.material.albedo_color = G.gray
	position = direction * POSITION_MULTIPLIER

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed and last_event == EventType.TOUCH:
			var color = G.color_manager.use_color(get_color())
			set_color(color)
		last_event = EventType.TOUCH
	elif event is InputEventScreenDrag:
		last_event = EventType.DRAG

func get_color() -> Color:
	return $Mesh.mesh.material.albedo_color

func set_color(color: Color):
	$Mesh.mesh.material.albedo_color = color

func clear_color():
	$Mesh.mesh.material.albedo_color = G.gray

func reset_color():
	var material = $Mesh.mesh.material
	var direction = position / POSITION_MULTIPLIER
	match direction.normalized():
		Vector3.UP:
			material.albedo_color = G.white
		Vector3.RIGHT:
			material.albedo_color = G.red
		Vector3.BACK: # Actually front
			material.albedo_color = G.green
		Vector3.DOWN:
			material.albedo_color = G.blue
		Vector3.LEFT:
			material.albedo_color = G.orange
		Vector3.FORWARD: # Actually back
			material.albedo_color = G.yellow
