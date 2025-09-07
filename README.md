## Godot Cube Solver

A small Godot 4.4 app that visualizes and solves a 3×3 Rubik’s Cube using the Min2Phase (Kociemba) method. Touch-friendly, moderately fast, and offline.

### Try it
- Android: export an APK in Godot (Project → Export → Android), then install it.

### Run from source
- Open this folder in Godot 4.4.
- Run the main scene: `scenes/main.tscn`.

### How to use
- Tap stickers to set colors, or use the UI buttons.
- Buttons: `Solve`, `Reset`, `Clear`, `Prev/Next`, and rotation helpers.
- The solver uses the bundled `addons/min2phase` port.