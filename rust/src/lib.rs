use godot::prelude::*;

struct Min2PhaseExtension;

#[gdextension]
unsafe impl ExtensionLibrary for Min2PhaseExtension {}

#[derive(GodotClass)]
#[class(base=Node)]
struct Solver {
    base: Base<Node>,
}

#[godot_api]
impl INode for Solver {
    fn init(base: Base<Node>) -> Self {
        godot_print!("Hello, Solver!");

        Self { base }
    }
}

#[godot_api]
impl Solver {
    #[func]
    fn solve(facelet: String) -> String {
        min2phase::solve(&facelet, 25)
    }
}
