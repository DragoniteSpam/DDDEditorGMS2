event_inherited();

repeat_action=false;
skip=true;
wait=true;

buffer=noone;
extra=false;
extra_xx=0;
extra_yy=0;
extra_zz=0;

// [[action0 id, params...], [action1 id, params...], [action2 id, params]...]
steps=ds_list_create();

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

