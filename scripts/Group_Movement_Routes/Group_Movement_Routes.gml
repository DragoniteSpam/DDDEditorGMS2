function MoveRoute() {
    self.repeat_action = false;
    self.skip = true;
    self.wait = true;
    
    self.extra = false;
    self.extra_xx = 0;
    self.extra_yy = 0;
    self.extra_zz = 0;
    
    // array of structs
    self.steps = [];
};

function move_route_make_visible(entity, route) {
    var n = array_length(entity.visible_routes);
    
    // are you already visible?
    for (var i = 0; i < n; i++) {
        if (entity.visible_routes[i] == route.GUID) return;
    }
    
    // are there any open slots?
    for (var i = 0; i < n; i++) {
        if (!guid_get(entity.visible_routes[i])) {
            entity.visible_routes[i] = route.GUID;
            return;
        }
    }
    
    // shift everything down
    for (var i = 0; i < n - 1; i++) {
        entity.visible_routes[i] = entity.visible_routes[i + 1];
    }
    
    entity.visible_routes[n - 1] = route.GUID;
}

function move_route_make_invisible(entity, route) {
    var n = array_length(entity.visible_routes);
    
    // are you already visible?
    for (var i = 0; i < n; i++) {
        if (entity.visible_routes[i] == route.GUID) {
            entity.visible_routes[i] = 0;
            return;
        }
    }
}

function move_route_update_buffer(route) {
    if (route.buffer) {
        vertex_delete_buffer(route.buffer);
        route.buffer = noone;
    }
    
    var xx = 0;
    var yy = 0;
    var zz = 0;         // this will not work well with sloped terrain
    var n_actions = 0;
    
    route.extra = false;
    
    // essentailly the rng seed
    var c = Stuff.color_lookup[string_hash_simple(route.GUID) % array_length(Stuff.color_lookup)];
    var cube_size = 2;
    
    var buffer = vertex_create_buffer();
    vertex_begin(buffer, Stuff.graphics.vertex_format);
    vertex_cube_line(buffer, 0, 0, 0, c, 1, cube_size);
    
    for (var i = 0; i < ds_list_size(route.steps); i++) {
        var data = route.steps[| i];
        var stop = false;
        
        switch (data[@ 0]) {
            // these either use some kind of random motion or use absolute coordinates,
            // so there's not much good in drawing them
            case MoveRouteActions.MOVE_RANDOM:
            case MoveRouteActions.MOVE_TOWARDS_PLAYER:
            case MoveRouteActions.MOVE_AWAY_PLAYER:
            case MoveRouteActions.MOVE_FORWARD:
            case MoveRouteActions.MOVE_BACKWARD:
            case MoveRouteActions.MOVE_TO:
            case MoveRouteActions.MOVE_JUMP:
                route.extra = true;
                route.extra_xx = xx;
                route.extra_yy = yy;
                route.extra_zz = zz;
                stop = true;
                break;
            // actual things
            case MoveRouteActions.MOVE_DOWN:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                yy += TILE_HEIGHT * data[@ 1];
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                n_actions++;
                break;
            case MoveRouteActions.MOVE_LEFT:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                xx = xx - TILE_WIDTH * data[@ 1];
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                n_actions++;
                break;
            case MoveRouteActions.MOVE_RIGHT:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                xx = xx + TILE_WIDTH * data[@ 1];
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                n_actions++;
                break;
            case MoveRouteActions.MOVE_UP:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                yy = yy - TILE_HEIGHT * data[@ 1];
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                n_actions++;
                break;
            case MoveRouteActions.MOVE_LOWER_LEFT:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                xx = xx - TILE_WIDTH * data[@ 1];
                yy += TILE_HEIGHT * data[@ 1];
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                n_actions++;
                break;
            case MoveRouteActions.MOVE_LOWER_RIGHT:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                xx = xx + TILE_WIDTH * data[@ 1];
                yy += TILE_HEIGHT * data[@ 1];
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                n_actions++;
                break;
            case MoveRouteActions.MOVE_UPPER_LEFT:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                xx = xx - TILE_WIDTH * data[@ 1];
                yy = yy - TILE_HEIGHT * data[@ 1];
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                n_actions++;
                break;
            case MoveRouteActions.MOVE_UPPER_RIGHT:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                xx = xx + TILE_WIDTH * data[@ 1];
                yy = yy - TILE_HEIGHT * data[@ 1];
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                n_actions++;
                break;
            case MoveRouteActions.MOVE_ACTUALLY_JUMP:
                vertex_point_line(buffer, xx, yy, zz, c, 1);
                vertex_point_line(buffer, xx, yy, zz + TILE_DEPTH * data[@ 1], c, 1);
                vertex_cube_line(buffer, xx, yy, zz + TILE_DEPTH * data[@ 1], c, 1, cube_size);
                n_actions++;
                break;
        }
        if (stop) {
            break;
        }
    }
    
    if (n_actions > 0) {
        vertex_end(buffer);
        vertex_freeze(buffer);
        route.buffer = buffer;
    } else {
        vertex_delete_buffer(buffer);
    }
}


enum MoveRouteActions {
    MOVE_DOWN,                  // [id, u8 distance]
    MOVE_LEFT,                  // [id, u8 distance]
    MOVE_RIGHT,                 // [id, u8 distance]
    MOVE_UP,                    // [id, u8 distance]
    MOVE_LOWER_LEFT,            // [id, u8 distance]
    MOVE_LOWER_RIGHT,           // [id, u8 distance]
    MOVE_UPPER_LEFT,            // [id, u8 distance]
    MOVE_UPPER_RIGHT,           // [id, u8 distance]
    MOVE_RANDOM,
    MOVE_TOWARDS_PLAYER,
    MOVE_AWAY_PLAYER,
    MOVE_FORWARD,
    MOVE_BACKWARD,
    MOVE_JUMP,                  // [id, string map id, u16 x, u16 y, u16 z, u8 direction]
    MOVE_ACTUALLY_JUMP,         // [id, f32 height]
    
    WAIT,                       // [id, f32 time]
    
    TURN_DOWN,
    TURN_LEFT,
    TURN_RIGHT,
    TURN_UP,
    TURN_90_RIGHT,
    TURN_90_LEFT,
    TURN_180,
    TURN_90_RANDOM,
    TURN_RANDOM,
    TURN_TOWARD_PLAYER,
    TURN_AWAY_PLAYER,
    
    SWITCH_ON,                  // [id, u8 self switch index]
    SWITCH_OFF,                 // [id, u8 self switch index]
    CHANGE_SPEED,               // [id, u8 speed 0...5]
    CHANGE_FREQUENCY,           // [id, u8 frequency 0...4]
    
    WALKING_ANIM_ON,
    WALKING_ANIM_OFF,
    STEPPING_ANIM_ON,
    STEPPING_ANIM_OFF,
    DIRECTION_FIX_ON,
    DIRECTION_FIX_OFF,
    SOLID_ON,
    SOLID_OFF,
    TRANSPARENT_ON,
    TRANSPARENT_OFF,
    
    CHANGE_GRAPHIC,             // [id, guid graphic id]        - this will be implemented differently for different entity types - texture uv vs model vs npc etc
    CHANGE_OPACITY,             // [id, f32 opacity]
    CHANGE_TINT,                // [id, u32 color]
    PLAY_SE,                    // [id, guid sound effect id]
    
    EVENT,                      // [id, guid event id, guid entrypoint id]
    
    MOVE_TO                     // [id, u16 x, u16 y]
}
