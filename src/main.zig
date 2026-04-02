const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;
const input = @import("input.zig");
const renderer = @import("renderer.zig");
const Scene = @import("scene.zig").Scene;

pub fn main() !void {
    rl.initWindow(800, 600, "My Engine");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var scene = Scene{};

    try scene.addEntity(Entity{ .transform = .{
        .position = .{ .x = 400, .y = 300 },
    }, .speed = 200.0 });

    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 200, .y = 200 },
        },
        .speed = 100.0,
    });

    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 600, .y = 400 },
        },
        .speed = 100.0,
    });

    while (!rl.windowShouldClose()) {

        // UPDATE
        const dt = rl.getFrameTime();

        input.processMovement(scene.getEntity(1), dt);

        // DRAW
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        for (scene.entities[0..scene.count]) |entity| {
            renderer.drawEntity(entity);
        }

        renderer.drawDebug(scene.getEntity(1).*);
    }
}
