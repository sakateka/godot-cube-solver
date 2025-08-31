extends Button

@onready var left: Label = $"../../Rotations/Panel/Text/Left"
@onready var right: Label = $"../../Rotations/Panel/Text/Right"

func get_opposite_move(move: String) -> String:
	if move.ends_with("2"):
		return move
		
	if move.ends_with("'"):
		return move.rstrip("'")
	else:
		return move + "'"
		
		
func _on_pressed() -> void:
	if G.cube.is_rotating():
		return

	var prev_rotation: String = get_prev_rotation()
	if prev_rotation.length() > 0:
		# FIXME: oposite rotation
		G.cube.rotate_layer(get_opposite_move(prev_rotation))

func get_prev_rotation() -> String:
	var left_text: String = left.text.strip_edges()
	if left_text.length() == 0:
		return ""
		
	var split = left_text.rsplit(" ", false, 1)
	var current: String = split[-1]
	var remaining: String = ""
	if split.size() > 1:
		remaining = split[0]
	
	right.text = current + " " + right.text.strip_edges()
	left.text = remaining
	return current
