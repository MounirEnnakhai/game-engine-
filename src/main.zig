const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;
const Collider = @import("entity.zig").Collider;
const Animation = @import("animator.zig").Animation;
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

    const run_texture = try rl.loadTexture("assets/RUN.png");
    defer rl.unloadTexture(run_texture);

    const idle_texture = try rl.loadTexture("assets/IDLE.png");
    defer rl.unloadTexture(idle_texture);

    var scene = Scene{};

    // player
    try scene.addEntity(Entity{
        .transform = .{
            .position = .{ .x = 200, .y = 200 },
            .scale = 2.0,
        },
        .speed = 300.0,
        .collider = Collider{
            .width = 32,
            .height = 38,
            .offset_y = 30.0,
        },
        .animator = Animation{
            .texture = idle_texture,
            .frame_width = @as(f32, @floatFromInt(idle_texture.width)) / 10.0,
            .frame_height = @as(f32, @floatFromInt(idle_texture.height)),
            .frame_count = 10,
            .frame_speed = 0.08,
        },
    });

    // ground
    try scene.addEntity(Entity{
        .transform = .{ .position = .{ .x = 0, .y = 568 } },
        .speed = 0.0,
        .collider = Collider{ .width = 3200, .height = 64 },
        .color = rl.Color{ .r = 34, .g = 139, .b = 34, .a = 255 },
    });

    // platform 1
    try scene.addEntity(Entity{
        .transform = .{ .position = .{ .x = 300, .y = 400 } },
        .speed = 0.0,
        .collider = Collider{ .width = 200, .height = 32 },
        .color = rl.Color{ .r = 139, .g = 90, .b = 43, .a = 255 },
    });

    // platform 2
    try scene.addEntity(Entity{
        .transform = .{ .position = .{ .x = 600, .y = 300 } },
        .speed = 0.0,
        .collider = Collider{ .width = 200, .height = 32 },
        .color = rl.Color{ .r = 139, .g = 90, .b = 43, .a = 255 },
    });

    // platform 3
    try scene.addEntity(Entity{
        .transform = .{ .position = .{ .x = 900, .y = 400 } },
        .speed = 0.0,
        .collider = Collider{ .width = 200, .height = 32 },
        .color = rl.Color{ .r = 139, .g = 90, .b = 43, .a = 255 },
    });

    // store both animations separately
    const run_anim = Animation{
        .texture = run_texture,
        .frame_width = @as(f32, @floatFromInt(run_texture.width)) / 16.0,
        .frame_height = @as(f32, @floatFromInt(run_texture.height)),
        .frame_count = 16,
        .frame_speed = 0.06,
    };

    const idle_anim = Animation{
        .texture = idle_texture,
        .frame_width = @as(f32, @floatFromInt(idle_texture.width)) / 10.0,
        .frame_height = @as(f32, @floatFromInt(idle_texture.height)),
        .frame_count = 10,
        .frame_speed = 0.08,
    };

    var camera = Camera.init(scene.getEntity(0).transform.position);
    var is_running = false;

    while (!rl.windowShouldClose()) {
        const dt = rl.getFrameTime();
        const player = scene.getEntity(0);

        input.processMovement(player, dt);
        physics.applyGravity(player, dt);
        physics.applyVelocity(player, dt);
        collision.resolveCollision(&scene, 0);
        camera.follow(player.*);

        // switch animation based on movement
        const moving = player.velocity.x != 0;

        if (moving and !is_running) {
            // switched to running
            is_running = true;
            const flip = if (player.animator != null) player.animator.?.flip_x else false;
            player.animator = run_anim;
            player.animator.?.flip_x = flip;
        } else if (!moving and is_running) {
            // switched to idle
            is_running = false;
            const flip = if (player.animator != null) player.animator.?.flip_x else false;
            player.animator = idle_anim;
            player.animator.?.flip_x = flip;
        }

        // update animation
        if (player.animator != null) {
            player.animator.?.update(dt);
        }

        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color{ .r = 30, .g = 30, .b = 30, .a = 255 });

        camera.begin();
        for (scene.entities[0..scene.count]) |entity| {
            renderer.drawEntity(entity);
            renderer.drawCollider(entity);
        }
        camera.end();

        renderer.drawDebug(scene.getEntity(0).*);
    }
}
