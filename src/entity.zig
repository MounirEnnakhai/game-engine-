const rl = @import("raylib");

pub const Transform = struct {
    position: rl.Vector2,
    rotation: f32 = 0.0,
    scale: f32 = 1.0,
};

pub const Entity = struct {
    transform: Transform,
    speed: f32,
    active: bool = true,
};
