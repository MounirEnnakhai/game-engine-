const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;
const collision = @import("collision.zig");

pub fn drawEntity(entity: Entity) void {
    if (!entity.active) return;

    if (entity.animator) |anim| {
        // has animator — draw current animation frame
        anim.draw(entity.transform.position, entity.transform.scale);
    } else if (entity.texture) |tex| {
        // has static texture
        const w = @as(f32, @floatFromInt(tex.width)) * entity.transform.scale;
        const h = @as(f32, @floatFromInt(tex.height)) * entity.transform.scale;
        rl.drawTextureEx(
            tex,
            rl.Vector2{
                .x = entity.transform.position.x - w / 2.0,
                .y = entity.transform.position.y - h / 2.0,
            },
            entity.transform.rotation,
            entity.transform.scale,
            rl.Color.white,
        );
    } else {
        // fallback — colored rectangle
        const rect = collision.getRect(entity);
        rl.drawRectangleRec(rect, entity.color);
    }
}

pub fn drawCollider(entity: Entity) void {
    if (entity.collider == null) return;
    const rect = collision.getRect(entity);
    rl.drawRectangleLinesEx(rect, 1, rl.Color.green);
}

pub fn drawDebug(entity: Entity) void {
    const x: i32 = @intFromFloat(entity.transform.position.x);
    const y: i32 = @intFromFloat(entity.transform.position.y);
    rl.drawFPS(10, 10);
    rl.drawText(
        rl.textFormat("pos: %d, %d", .{ x, y }),
        10,
        30,
        20,
        rl.Color.green,
    );
}
