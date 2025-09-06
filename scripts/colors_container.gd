class_name ColorManager
extends HBoxContainer

var labels: Array[Label]
var buttons: Array[Button]
var current_color_idx: int = 0

var colors: Array[Color] = [G.white, G.red, G.green, G.blue, G.orange, G.yellow]
const facelet_letters: Array[String] = ["U", "R", "F", "D", "L", "B", "."]
var color_use_counts: Array[int] = [0, 0, 0, 0 ,0, 0]

signal face_color_changed

func _ready():
	labels = [
		$Up/WhiteLabel, $Right/RedLabel, $Front/GreenLabel,
		$Down/BlueLabel, $Left/OrangeLabel, $Back/YellowLabel,
	]
	buttons = [
		$Up/White, $Right/Red, $Front/Green,
		$Down/Blue, $Left/Orange, $Back/Yellow,
	]
	
	$Up/WhiteLabel.add_theme_color_override("font_color", G.focus)
	G.color_manager = self
	
	var solve_btn: SolveButton = $"../../Footer/SolveControls/Solve" as SolveButton
	face_color_changed.connect(solve_btn._on_face_color_changed.bind(solve_btn))

func colors_available() -> bool:
	var not_equal_9 = func(x: int) -> bool:
		return x != 9
	return color_use_counts.any(not_equal_9)

func color_to_facelet_letter(color: Color) -> String:
	var idx = colors.find(color)
	return facelet_letters[idx]

func update_color_ui_for(idx: int) -> void:
	var label: Label = labels[idx]
	var count: int = color_use_counts[idx]
	label.text = String.num_int64(count)
	buttons[idx].disabled = count == 9

func use_color(face_color: Color) -> Color:
	var face_color_idx = colors.find(face_color)
	
	if face_color_idx == current_color_idx:
		color_use_counts[face_color_idx] = max(color_use_counts[face_color_idx] - 1, 0)
		buttons[face_color_idx].disabled = false
		update_color_ui_for(face_color_idx)  # force update old label text	
		return G.gray
	
	var current = color_use_counts[current_color_idx]

	# First we allow to decolor other color
	if face_color_idx != -1:
		color_use_counts[face_color_idx] = max(color_use_counts[face_color_idx] - 1, 0)
		update_color_ui_for(face_color_idx)  # force update old label text	
	
	# But if the current color is exhausted we should return gray
	if current == 9:
		return G.gray
		
	color_use_counts[current_color_idx] = min(current + 1, 9)
	
	update_color_ui_for(current_color_idx)  # force update new label text
	return colors[current_color_idx]

func on_color_pressed(idx: int) -> void:
	current_color_idx = idx
	for lbl in labels:
		lbl.add_theme_color_override("font_color", G.white)
	labels[idx].add_theme_color_override("font_color", G.focus)

func mark_all_colors_as_unused() -> void:
	for idx in range(color_use_counts.size()):
		color_use_counts[idx] = 0
		update_color_ui_for(idx)
	face_color_changed.emit()

func mark_all_colors_as_used() -> void:
	for idx in range(color_use_counts.size()):
		color_use_counts[idx] = 9
		update_color_ui_for(idx)
	face_color_changed.emit()


func _on_white_focus_entered() -> void:
	on_color_pressed(0)

func _on_red_focus_entered() -> void:
	on_color_pressed(1)

func _on_green_focus_entered() -> void:
	on_color_pressed(2)

func _on_blue_focus_entered() -> void:
	on_color_pressed(3)

func _on_orange_focus_entered() -> void:
	on_color_pressed(4)
	
func _on_yellow_focus_entered() -> void:
	on_color_pressed(5)
