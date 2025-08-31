extends Button

@onready var left: Label = $"../../Rotations/Panel/Text/Left"
@onready var right: Label = $"../../Rotations/Panel/Text/Right"

func _on_pressed() -> void:
	if G.cube.is_rotating():
		return

	var next_rotation: String = get_next_rotation()
	if next_rotation.length() > 0:
		G.cube.rotate_layer(next_rotation)

func get_next_rotation() -> String:
	var right_text: String = right.text.strip_edges()
	if right_text.length() == 0:
		return ""
		
	var split = right_text.split(" ", false, 1)
	var current: String = split[0]
	var remaining: String = ""
	if split.size() > 1:
		remaining = split[1]
	
	left.text = left.text.strip_edges() + " " + current
	right.text = remaining
	return current
