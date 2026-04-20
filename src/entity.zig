const rl = @import("raylib");
const Animation = @import("animator.zig").Animation;

pub const Transform = struct {
    position: rl.Vector2,
    rotation: f32 = 0.0,
    scale: f32 = 1.0,
};

pub const Collider = struct {
    width: f32,
    height: f32,
    offset_x: f32 = 0.0,
    offset_y: f32 = 0.0,
    active: bool = true,
};

pub const Entity = struct {
    transform: Transform,
    speed: f32,
    velocity: rl.Vector2 = .{ .x = 0, .y = 0 },
    is_grounded: bool = false,
    active: bool = true,
    texture: ?rl.Texture = null,
    collider: ?Collider = null,
    color: rl.Color = rl.Color.sky_blue,
    animator: ?Animation = null,
};
