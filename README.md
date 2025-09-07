## Godot Cube Solver

<img width="216" height="468" alt="Screenshot_1" src="https://github.com/user-attachments/assets/23f65a47-5ef7-45f2-b63b-bd60c7d2f3b9" />
<img width="216" height="468" alt="Screenshot_2" src="https://github.com/user-attachments/assets/3316ed75-af3f-4b63-8824-784a55fd2fe4" />
<img width="216" height="468" alt="Screenshot_3" src="https://github.com/user-attachments/assets/2571d162-9ae4-437f-a5a4-f36d7b300f29" />

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
