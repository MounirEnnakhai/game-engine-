const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;
const physics = @import("physics.zig");

pub fn processMovement(entity: *Entity, dt: f32) void {
    if (!entity.active) return;

    entity.velocity.x = 0;

    if (rl.isKeyDown(.d)) {
        entity.velocity.x = entity.speed;
        // face right
        if (entity.animator != null) {
            entity.animator.?.flip_x = false;
        }
    }
    if (rl.isKeyDown(.a)) {
        entity.velocity.x = -entity.speed;
        // face left — flip the sprite
        if (entity.animator != null) {
            entity.animator.?.flip_x = true;
        }
    }

    if (rl.isKeyDown(.space)) physics.jump(entity);

    _ = dt;
}
