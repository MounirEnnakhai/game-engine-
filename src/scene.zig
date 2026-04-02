const Entity = @import("entity.zig").Entity;

const MAX_ENTITIES = 128;

pub const Scene = struct {
    entities: [MAX_ENTITIES]Entity = undefined,
    count: usize = 0,

    pub fn addEntity(self: *Scene, entity: Entity) !void {
        if (self.count >= MAX_ENTITIES) return error.SceneFull;
        self.entities[self.count] = entity;
        self.count += 1;
    }

    pub fn getEntity(self: *Scene, index: usize) *Entity {
        return &self.entities[index];
    }
};
