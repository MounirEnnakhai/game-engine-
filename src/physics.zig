const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;

const GRAVITY: f32 = 1500.0;
const JUMP_FORCE: f32 = -600.0;
const MAX_FALL_SPEED: f32 = 1000.0;

pub fn applyGravity(entity: *Entity, dt: f32) void {
    if (entity.is_grounded) return;

    entity.velocity.y += GRAVITY * dt;

    if (entity.velocity.y > MAX_FALL_SPEED) {
        entity.velocity.y = MAX_FALL_SPEED;
    }
}

pub fn applyVelocity(entity: *Entity, dt: f32) void {
    entity.transform.position.x += entity.velocity.x * dt;
    entity.transform.position.y += entity.velocity.y * dt;
}

pub fn jump(entity: *Entity) void {
    if (!entity.is_grounded) return;
    entity.velocity.y = JUMP_FORCE;
    entity.is_grounded = false;
}
