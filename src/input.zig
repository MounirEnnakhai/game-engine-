const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;
const physics = @import("physics.zig");

pub fn processMovement(entity: *Entity, dt: f32) void {
    if (!entity.active) return;

    entity.velocity.x = 0;
    if (rl.isKeyDown(.d)) entity.velocity.x += entity.speed;
    if (rl.isKeyDown(.a)) entity.velocity.x -= entity.speed;

    if (rl.isKeyDown(.space)) physics.jump(entity);

    _ = dt;
}
