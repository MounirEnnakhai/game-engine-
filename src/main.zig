const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;
const Collider = @import("entity.zig").Collider;
const Scene = @import("scene.zig").Scene;
const Camera = @import("camera.zig").Camera;
const input = @import("input.zig");
const renderer = @import("renderer.zig");
const collision = @import("collision.zig");
const physics = @import("physics.zig");

pub fn main() !void {
    rl.initWindow(800, 600, "My Engine");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    const player_texture = try rl.loadTexture("assets/player01.png");
    defer rl.unloadTexture(player_texture);

    const tex_w = @as(f32, @floatFromInt(player_texture.width));
    const tex_h = @as(f32, @floatFromInt(player_texture.height));

    var scene = Scene{};

    // player
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 200, .y = 200 },
            .scale = 0.3,
        },
        .speed = 300.0,
        .texture = player_texture,
        .collider = Collider{ .width = tex_w - 50, .height = tex_h },
    });

    // ground — wide and at the bottom
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 0, .y = 568 },
        },
        .speed = 0.0,
        .collider = Collider{ .width = 3200, .height = 64 },
        .color = rl.Color{ .r = 34, .g = 139, .b = 34, .a = 255 },
    });

    // platform 1
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 300, .y = 400 },
        },
        .speed = 0.0,
        .collider = Collider{ .width = 200, .height = 32 },
        .color = rl.Color{ .r = 139, .g = 90, .b = 43, .a = 255 },
    });

    // platform 2
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 600, .y = 300 },
        },
        .speed = 0.0,
        .collider = Collider{ .width = 200, .height = 32 },
        .color = rl.Color{ .r = 139, .g = 90, .b = 43, .a = 255 },
    });

    // platform 3
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 900, .y = 400 },
        },
        .speed = 0.0,
        .collider = Collider{ .width = 200, .height = 32 },
        .color = rl.Color{ .r = 139, .g = 90, .b = 43, .a = 255 },
    });

    var camera = Camera.init(scene.getEntity(0).transform.position);

    while (!rl.windowShouldClose()) {
        const dt = rl.getFrameTime();

        input.processMovement(scene.getEntity(0), dt);
        physics.applyGravity(scene.getEntity(0), dt);
        physics.applyVelocity(scene.getEntity(0), dt);
        collision.resolveCollision(&scene, 0);
        camera.follow(scene.getEntity(0).*);

        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color{ .r = 30, .g = 30, .b = 30, .a = 255 });

        camera.begin();
        for (scene.entities[0..scene.count]) |entity| {
            renderer.drawEntity(entity);
        }
        camera.end();

        renderer.drawDebug(scene.getEntity(0).*);
    }
}
