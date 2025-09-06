extends Button

@onready var left: Label = $"../../Rotations/Panel/Text/Left"
@onready var right: Label = $"../../Rotations/Panel/Text/Right"

@onready var normal_color: Color = get("theme_override_styles/normal").get("bg_color")
@onready var hover_color: Color = get("theme_override_styles/normal").get("bg_color")
@onready var focus_color: Color = get("theme_override_styles/normal").get("bg_color")


func _on_face_color_changed(solve_btn: Button):
	print("Face color changend")
	get("theme_override_styles/normal").set("bg_color", normal_color)
	get("theme_override_styles/hover").set("bg_color", hover_color)
	get("theme_override_styles/focus").set("bg_color", focus_color)
	solve_btn.disabled = G.color_manager.colors_available()

func _on_pressed() -> void:
	print("Solve pressed!")
	var facelet: String = G.cube.get_facelet()
	var solution: String = Solver.solve(facelet)
	print("Facelet: ", facelet, " Solution: ", solution)
	if not solution.begins_with("Error"):
		left.text = ""
		right.text = solution
		get("theme_override_styles/normal").set("bg_color", normal_color)
		get("theme_override_styles/hover").set("bg_color", hover_color)
		get("theme_override_styles/focus").set("bg_color", focus_color)
	else:
		get("theme_override_styles/normal").set("bg_color", Color.RED)
		get("theme_override_styles/hover").set("bg_color", Color.RED)
		get("theme_override_styles/focus").set("bg_color", Color.RED)
