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

    const player_texture = try rl.loadTexture("assets/player11.png");
    defer rl.unloadTexture(player_texture);

    const tex_w = @as(f32, @floatFromInt(player_texture.width));
    const tex_h = @as(f32, @floatFromInt(player_texture.height));

    var scene = Scene{};

    // player with collider
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 400, .y = 300 },
            .scale = 0.5,
        },
        .speed = 200.0,
        .texture = player_texture,
        .collider = Collider{ .width = tex_w, .height = tex_h },
    });

    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 400, .y = 700 },
            .scale = 0.5,
        },
        .speed = 200.0,
        .collider = Collider{ .width = tex_w, .height = tex_h },
    });

    // static entity with collider — solid obstacle
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 200, .y = 200 },
            .scale = 1.0,
        },
        .speed = 0.0,
        .collider = Collider{ .width = 64, .height = 64 },
    });

    // static entity with collider
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 600, .y = 400 },
            .scale = 1.0,
        },
        .speed = 0.0,
        .collider = Collider{ .width = 64, .height = 64 },
    });

    var camera = Camera.init(scene.getEntity(0).transform.position);

    while (!rl.windowShouldClose()) {

        // UPDATE
        const dt = rl.getFrameTime();
        input.processMovement(scene.getEntity(0), dt);

        physics.applyGravity(scene.getEntity(0), dt);

        physics.applyVelocity(scene.getEntity(0), dt);

        collision.resolveCollision(&scene, 0);

        camera.follow(scene.getEntity(0).*);

        // DRAW
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        camera.begin();
        for (scene.entities[0..scene.count]) |entity| {
            renderer.drawEntity(entity);
            renderer.drawCollider(entity);
        }
        camera.end();

        renderer.drawDebug(scene.getEntity(0).*);
    }
}
