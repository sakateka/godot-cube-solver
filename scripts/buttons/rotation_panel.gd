extends PanelContainer

@onready var left: Label = $"../UI/Footer/Rotations/Panel/Text/Left"
@onready var right: Label = $"../UI/Footer/Rotations/Panel/Text/Right"
@onready var buttons: VBoxContainer = $VBoxContainer

func _ready() -> void:	
	visible = false
	
	for child in buttons.get_children():
		if child is not HBoxContainer:
			continue
		
		for btn_child in child.get_children():
			var btn: Button = btn_child as Button
			var handler = func():
				on_move_button_pressed(btn)
			btn.pressed.connect(handler)

func on_move_button_pressed(button: Button):
	print("Button pressed: ", button.text)
	right.text += " " + button.text

				
func _on_close_pressed() -> void:
	_on_rotations_pressed()

func _on_rotations_pressed() -> void:
	visible = !visible
	if visible:
		left.text = ""
		right.text = ""
		right.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	else:
		right.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT


func _on_backspace_pressed() -> void:
	var split = right.text.strip_edges().rsplit(" ", true, 1)
	var remaining = ""
	if split.size() > 1:
		remaining = split[0]
	
	right.text = remaining
