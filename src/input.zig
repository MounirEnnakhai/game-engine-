const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;

pub fn processMovement(entity: *Entity, dt: f32) void {
    if (!entity.active) return;

    const vel = entity.speed * dt;
    if (rl.isKeyDown(.right)) entity.transform.position.x += vel;
    if (rl.isKeyDown(.left)) entity.transform.position.x -= vel;
    if (rl.isKeyDown(.down)) entity.transform.position.y += vel;
    if (rl.isKeyDown(.up)) entity.transform.position.y -= vel;
}
