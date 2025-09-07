class_name SolveButton
extends Button

@onready var left: Label = $"../../Rotations/Panel/Text/Left"
@onready var right: Label = $"../../Rotations/Panel/Text/Right"

@onready var normal_color: Color = get("theme_override_styles/normal").get("bg_color")
@onready var hover_color: Color = get("theme_override_styles/hover").get("bg_color")
@onready var focus_color: Color = get("theme_override_styles/focus").get("bg_color")

# Background solving variables
var solve_thread: Thread
var is_solving: bool = false
var animation_tween: Tween


func _on_face_color_changed(solve_btn: SolveButton):
	print("Face color changend")
	get("theme_override_styles/normal").set("bg_color", normal_color)
	get("theme_override_styles/hover").set("bg_color", hover_color)
	get("theme_override_styles/focus").set("bg_color", focus_color)
	solve_btn.disabled = G.color_manager.colors_available()

func _on_pressed() -> void:
	if is_solving:
		# Stop the current solving process
		stop_solving()
	else:
		# Start solving in background
		start_solving()

func start_solving() -> void:
	if is_solving:
		return

	print("Starting background solve...")
	is_solving = true

	# Reset the global cancellation flag
	Min2PhaseInstance.global_sctx.should_stop = false

	# Get facelet from main thread before starting background thread
	var facelet: String = G.cube.get_facelet()

	# Change button text and start animation
	text = "Stop"
	start_animation()

	# Create and start background thread with facelet parameter
	solve_thread = Thread.new()
	solve_thread.start(_solve_in_background.bind(facelet))

func stop_solving() -> void:
	if not is_solving:
		return

	print("Stopping solve...")
	# Set the global cancellation flag
	Min2PhaseInstance.global_sctx.should_stop = true

func _solve_in_background(facelet: String) -> void:
	print("Facelet: ", facelet)

	# Call the solve function in background thread
	var solution: String = Min2PhaseInstance.solve(facelet, 25)

	print("Solution: ", solution)

	# Store result for main thread
	call_deferred("_on_solve_completed", solution)

func _on_solve_completed(solution: String = "") -> void:
	is_solving = false

	# Reset button text
	text = "Solve"

	# Stop animation
	stop_animation()

	# Clean up thread (but don't wait for it to finish)
	if solve_thread:
		solve_thread.wait_to_finish()
		solve_thread = null

	# Update UI with solution
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


func start_animation() -> void:
	# Create pulsating color animation
	animation_tween = create_tween()
	animation_tween.set_loops()

	# Define colors for pulsation
	var color1 = Color(0.2, 0.8, 0.2, 1.0)  # Green
	var color2 = Color(0.8, 0.2, 0.2, 1.0)  # Red
	var color3 = Color(0.2, 0.2, 0.8, 1.0)  # Blue

	# Animate between colors
	animation_tween.tween_property(self, "modulate", color1, 0.5)
	animation_tween.tween_property(self, "modulate", color2, 0.5)
	animation_tween.tween_property(self, "modulate", color3, 0.5)
	animation_tween.tween_property(self, "modulate", Color.WHITE, 0.5)

func stop_animation() -> void:
	if animation_tween:
		animation_tween.kill()
		animation_tween = null

	# Reset to normal color
	modulate = Color.WHITE

func _exit_tree() -> void:
	# Clean up when node is removed
	if is_solving:
		stop_solving()
		solve_thread.wait_to_finish()
