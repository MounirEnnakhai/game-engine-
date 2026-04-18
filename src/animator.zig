const rl = @import("raylib");

pub const Animation = struct {
    texture: rl.Texture,
    frame_width: f32,
    frame_height: f32,
    frame_count: usize,
    frame_speed: f32, // seconds per frame
    frame_current: usize = 0,
    timer: f32 = 0.0,
    flip_x: bool = false, // flip horizontally for left movement

    pub fn update(self: *Animation, dt: f32) void {
        self.timer += dt;
        if (self.timer >= self.frame_speed) {
            self.timer = 0.0;
            self.frame_current = (self.frame_current + 1) % self.frame_count;
        }
    }

    pub fn draw(self: Animation, position: rl.Vector2, scale: f32) void {
        // source rectangle — which frame to cut from the spritesheet
        const src = rl.Rectangle{
            .x = @as(f32, @floatFromInt(self.frame_current)) * self.frame_width,
            .y = 0,
            .width = if (self.flip_x) -self.frame_width else self.frame_width,
            .height = self.frame_height,
        };

        // destination rectangle — where and how big to draw on screen
        const dst = rl.Rectangle{
            .x = position.x,
            .y = position.y,
            .width = self.frame_width * scale,
            .height = self.frame_height * scale,
        };

        rl.drawTexturePro(
            self.texture,
            src,
            dst,
            rl.Vector2{
                .x = self.frame_width * scale / 2.0,
                .y = self.frame_height * scale / 2.0,
            },
            0.0,
            rl.Color.white,
        );
    }
};
