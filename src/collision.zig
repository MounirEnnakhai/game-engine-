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
    const w = col.width * entity.transform.scale;
    const h = col.height * entity.transform.scale;
    return rl.Rectangle{
        .x = entity.transform.position.x - w / 2.0,
        .y = entity.transform.position.y - h / 2.0,
        .width = w,
        .height = h,
    };
}

pub fn resolveCollision(scene: *Scene, player_index: usize) void {
    const player = scene.getEntity(player_index);
    if (player.collider == null) return;

    player.is_grounded = false;

    for (scene.entities[0..scene.count], 0..) |*entity, i| {
        if (i == player_index) continue;
        if (!entity.active) continue;
        if (entity.collider == null) continue;

        // recompute every iteration so position changes are reflected
        const player_rect = getRect(player.*);
        const other_rect = getRect(entity.*);

        if (rl.checkCollisionRecs(player_rect, other_rect)) {
            const player_center_x = player_rect.x + player_rect.width / 2.0;
            const player_center_y = player_rect.y + player_rect.height / 2.0;
            const other_center_x = other_rect.x + other_rect.width / 2.0;
            const other_center_y = other_rect.y + other_rect.height / 2.0;

            const overlap_x = player_center_x - other_center_x;
            const overlap_y = player_center_y - other_center_y;

            const half_widths = (player_rect.width + other_rect.width) / 2.0;
            const half_heights = (player_rect.height + other_rect.height) / 2.0;

            const pen_x = half_widths - @abs(overlap_x);
            const pen_y = half_heights - @abs(overlap_y);

            if (pen_x < pen_y) {
                // horizontal collision
                if (overlap_x > 0) {
                    player.transform.position.x += pen_x;
                } else {
                    player.transform.position.x -= pen_x;
                }
                player.velocity.x = 0;
            } else {
                // vertical collision
                if (overlap_y > 0) {
                    // player center is BELOW other center
                    // meaning player hit the ceiling
                    player.transform.position.y += pen_y;
                    player.velocity.y = 0;
                } else {
                    // player center is ABOVE other center
                    // meaning player landed on top
                    player.transform.position.y -= pen_y;
                    player.velocity.y = 0;
                    player.is_grounded = true;
                }
            }
        }
    }
}
