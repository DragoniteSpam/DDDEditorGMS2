function MoveRoute(source) constructor {
    self.name = source;
    
    self.repeat_action = false;
    self.skip = true;
    self.wait = true;
    
    // array of structs
    self.steps = [];
    
    static Export = function(buffer) {
        buffer_write(buffer, buffer_field, pack(
            self.repeat_action,
            self.skip,
            self.wait
        ));
        buffer_write(buffer, buffer_u16, ds_list_size(self.steps));
        
        // we'll clean this up some other day
        for (var i = 0; i < ds_list_size(self.steps); i++) {
            var step = self.steps[| i];
            
            buffer_write(buffer, buffer_u16, step[@ 0]);
            switch (step[@ 0]) {
                case MoveRouteActions.MOVE_DOWN:
                case MoveRouteActions.MOVE_LEFT:
                case MoveRouteActions.MOVE_RIGHT:
                case MoveRouteActions.MOVE_UP:
                case MoveRouteActions.MOVE_LOWER_LEFT:
                case MoveRouteActions.MOVE_LOWER_RIGHT:
                case MoveRouteActions.MOVE_UPPER_LEFT:
                case MoveRouteActions.MOVE_UPPER_RIGHT:
                    buffer_write(buffer, buffer_u8, step[@ 1]);
                    break;
                // were always there
                case MoveRouteActions.MOVE_JUMP:
                    buffer_write(buffer, buffer_string, step[@ 1]);
                    buffer_write(buffer, buffer_u16, step[@ 2]);
                    buffer_write(buffer, buffer_u16, step[@ 3]);
                    buffer_write(buffer, buffer_u16, step[@ 4]);
                    buffer_write(buffer, buffer_u8, step[@ 5]);
                    break;
                case MoveRouteActions.MOVE_ACTUALLY_JUMP:
                    buffer_write(buffer, buffer_f32, step[@ 1]);
                    break;
                case MoveRouteActions.WAIT:
                    buffer_write(buffer, buffer_f32, step[@ 1]);
                    break;
                case MoveRouteActions.SWITCH_ON:
                    buffer_write(buffer, buffer_u8, step[@ 1]);
                    break;
                case MoveRouteActions.SWITCH_OFF:
                    buffer_write(buffer, buffer_u8, step[@ 1]);
                    break;
                case MoveRouteActions.CHANGE_SPEED:
                    buffer_write(buffer, buffer_u8, step[@ 1]);
                    break;
                case MoveRouteActions.CHANGE_FREQUENCY:
                    buffer_write(buffer, buffer_u8, step[@ 1]);
                    break;
                case MoveRouteActions.CHANGE_GRAPHIC:
                    buffer_write(buffer, buffer_datatype, step[@ 1]);
                    break;
                case MoveRouteActions.CHANGE_OPACITY:
                    buffer_write(buffer, buffer_f32, step[@ 1]);
                    break;
                case MoveRouteActions.CHANGE_TINT:
                    buffer_write(buffer, buffer_u8, step[@ 1]);
                    break;
                case MoveRouteActions.PLAY_SE:
                    buffer_write(buffer, buffer_datatype, step[@ 1]);
                    break;
                case MoveRouteActions.EVENT:
                    buffer_write(buffer, buffer_datatype, step[@ 1]);
                    buffer_write(buffer, buffer_datatype, step[@ 2]);
                    break;
                case MoveRouteActions.MOVE_TO:
                    buffer_write(buffer, buffer_u16, step[@ 1]);
                    buffer_write(buffer, buffer_u16, step[@ 2]);
                    break;
            }
        }
    };
    
    if (is_struct(source)) {
        self.name = source.name;
        self.repeat_action = source.repeat_action;
        self.skip = source.skip;
        self.wait = source.wait;
        self.steps = source.steps;
    }
};

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
