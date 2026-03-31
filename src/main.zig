const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;
const input = @import("input.zig");
const renderer = @import("renderer.zig");

pub fn main() void {
    rl.initWindow(800, 600, "My Engine");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var player = Entity{
        .transform = .{
            .position = .{ .x = 400, .y = 300 },
        },
        .speed = 200.0,
    };

    while (!rl.windowShouldClose()) {

        // UPDATE
        const dt = rl.getFrameTime();
        input.processMovement(&player, dt);

        // DRAW
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);
        renderer.drawEntity(player);
        renderer.drawDebug(player);
    }
}
