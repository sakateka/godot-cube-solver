class_name Globals extends Node

enum CubieType {
	ROOT,
	CENTER,
	EDGE,
	CORNER,
}

@export var white = Color.WHITE
@export var blue = Color.BLUE
@export var red = Color.RED
@export var yellow = Color.YELLOW
@export var green = Color.WEB_GREEN
@export var orange = Color.DARK_ORANGE
@export var gray = Color.DIM_GRAY

var facelet: Array;

const solved_facelets = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
