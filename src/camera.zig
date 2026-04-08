const rl = @import("raylib");
const Entity = @import("entity.zig").Entity;

const SCREEN_WIDTH = 800.0;
const SCREEN_HEIGHT = 600.0;

// how close to the edge before camera moves
const DEADZONE_X = 200.0;
const DEADZONE_Y = 150.0;

pub const Camera = struct {
    handle: rl.Camera2D,

    pub fn init(target: rl.Vector2) Camera {
        return Camera{
            .handle = rl.Camera2D{
                .target = target,
                .offset = rl.Vector2{
                    .x = SCREEN_WIDTH / 2.0,
                    .y = SCREEN_HEIGHT / 2.0,
                },
                .rotation = 0.0,
                .zoom = 1.0,
            },
        };
    }

    pub fn follow(self: *Camera, entity: Entity) void {
        const pos = entity.transform.position;
        const target = self.handle.target;

        // how far is the player from the camera target
        const dx = pos.x - target.x;
        const dy = pos.y - target.y;

        // only move camera if player is outside deadzone
        if (dx > DEADZONE_X) self.handle.target.x += dx - DEADZONE_X;
        if (dx < -DEADZONE_X) self.handle.target.x += dx + DEADZONE_X;
        if (dy > DEADZONE_Y) self.handle.target.y += dy - DEADZONE_Y;
        if (dy < -DEADZONE_Y) self.handle.target.y += dy + DEADZONE_Y;
    }

    pub fn begin(self: Camera) void {
        rl.beginMode2D(self.handle);
    }

    pub fn end(_: Camera) void {
        rl.endMode2D();
    }
};
