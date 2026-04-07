const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;

pub fn drawEntity(entity: Entity) void {
    if (!entity.active) return;

    if (entity.texture) |tex| {
        rl.drawTextureEx(
            tex,
            entity.transform.position,
            entity.transform.rotation,
            entity.transform.scale,
            rl.Color.white,
        );
    } else {
        rl.drawCircleV(
            entity.transform.position,
            32 * entity.transform.scale,
            rl.Color.sky_blue,
        );
    }
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
