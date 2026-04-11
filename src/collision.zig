const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;
const Scene = @import("scene.zig").Scene;

pub fn getRect(entity: Entity) rl.Rectangle {
    const col = entity.collider orelse return rl.Rectangle{
        .x = 0,
        .y = 0,
        .width = 0,
        .height = 0,
    };
    return rl.Rectangle{
        .x = entity.transform.position.x,
        .y = entity.transform.position.y,
        .width = col.width * entity.transform.scale,
        .height = col.height * entity.transform.scale,
    };
}

pub fn resolveCollision(scene: *Scene, player_index: usize) void {
    const player = scene.getEntity(player_index);
    if (player.collider == null) return;

    const player_rect = getRect(player.*);

    for (scene.entities[0..scene.count], 0..) |entity, i| {
        if (i == player_index) continue;
        if (!entity.active) continue;
        if (entity.collider == null) continue;

        const other_rect = getRect(entity);

        if (rl.checkCollisionRecs(player_rect, other_rect)) {
            const overlap_x = (player_rect.x + player_rect.width / 2.0) - (other_rect.x + other_rect.width / 2.0);
            const overlap_y = (player_rect.y + player_rect.height / 2.0) - (other_rect.y + other_rect.width / 2.0);

            const half_widths = (player_rect.width + other_rect.width) / 2.0;
            const half_heights = (player_rect.height + other_rect.height) / 2.0;

            const pen_x = half_widths - @abs(overlap_x);
            const pen_y = half_heights - @abs(overlap_y);

            if (pen_x < pen_y) {
                if (overlap_x > 0) {
                    player.transform.position.x += pen_x;
                } else {
                    player.transform.position.x -= pen_x;
                }
            } else {
                if (overlap_y > 0) {
                    player.transform.position.y += pen_y;
                } else {
                    player.transform.position.y -= pen_y;
                }
            }
        }
    }
}
