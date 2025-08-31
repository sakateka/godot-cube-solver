extends Button

func _on_pressed() -> void:
	print("Solve pressed!")
	var facelet: String = G.cube.get_facelet()
	print("Facelet: ", facelet)
