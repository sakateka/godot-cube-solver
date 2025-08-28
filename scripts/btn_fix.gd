extends Button

var cube: Cube

func _on_pressed() -> void:
	if cube == null:
		cube = get_node("/root/World/Cube")
		
	if cube.is_rotating():
		return

	var next_rotation: String = get_next_rotation()
	cube.rotate_layer(next_rotation)


func get_next_rotation() -> String:
	return "R"
