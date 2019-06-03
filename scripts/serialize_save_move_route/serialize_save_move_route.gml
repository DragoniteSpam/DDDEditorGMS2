/// @description void serialize_save_move_route(buffer, DataMoveRoute);
/// @param buffer
/// @param DataMoveRoute

// name, guid, flags
serialize_save_generic(argument0, argument1);

var bools=pack(argument1.repeat_action,
    argument1.skip,
    argument1.wait);

buffer_write(argument0, buffer_u16, bools);

var n_steps=ds_list_size(argument1.steps);
buffer_write(argument0, buffer_u16, n_steps);

for (var i=0; i<n_steps; i++) {
    var step=argument1.steps[| i];
    
    buffer_write(argument0, buffer_u16, step[@ 0]);
    switch(step[@ 0]) {
        // DataVersions.MOVE_ROUTE_MOVE_PARAMS
        case MoveRouteActions.MOVE_DOWN:
        case MoveRouteActions.MOVE_LEFT:
        case MoveRouteActions.MOVE_RIGHT:
        case MoveRouteActions.MOVE_UP:
        case MoveRouteActions.MOVE_LOWER_LEFT:
        case MoveRouteActions.MOVE_LOWER_RIGHT:
        case MoveRouteActions.MOVE_UPPER_LEFT:
        case MoveRouteActions.MOVE_UPPER_RIGHT:
            buffer_write(argument0, buffer_u8, step[@ 1]);
            break;
        // were always there
        case MoveRouteActions.MOVE_JUMP:
            buffer_write(argument0, buffer_string, step[@ 1]);
            buffer_write(argument0, buffer_u16, step[@ 2]);
            buffer_write(argument0, buffer_u16, step[@ 3]);
            buffer_write(argument0, buffer_u16, step[@ 4]);
            buffer_write(argument0, buffer_u8, step[@ 5]);
            break;
        case MoveRouteActions.MOVE_ACTUALLY_JUMP:
            buffer_write(argument0, buffer_f32, step[@ 1]);
            break;
        case MoveRouteActions.WAIT:
            buffer_write(argument0, buffer_f32, step[@ 1]);
            break;
        case MoveRouteActions.SWITCH_ON:
            buffer_write(argument0, buffer_u8, step[@ 1]);
            break;
        case MoveRouteActions.SWITCH_OFF:
            buffer_write(argument0, buffer_u8, step[@ 1]);
            break;
        case MoveRouteActions.CHANGE_SPEED:
            buffer_write(argument0, buffer_u8, step[@ 1]);
            break;
        case MoveRouteActions.CHANGE_FREQUENCY:
            buffer_write(argument0, buffer_u8, step[@ 1]);
            break;
        case MoveRouteActions.CHANGE_GRAPHIC:
            buffer_write(argument0, buffer_u32, step[@ 1]);
            break;
        case MoveRouteActions.CHANGE_OPACITY:
            buffer_write(argument0, buffer_f32, step[@ 1]);
            break;
        case MoveRouteActions.CHANGE_TINT:
            buffer_write(argument0, buffer_u8, step[@ 1]);
            break;
        case MoveRouteActions.PLAY_SE:
            buffer_write(argument0, buffer_u32, step[@ 1]);
            break;
        case MoveRouteActions.EVENT:
            buffer_write(argument0, buffer_u32, step[@ 1]);
            buffer_write(argument0, buffer_u32, step[@ 2]);
            break;
        case MoveRouteActions.MOVE_TO:
            buffer_write(argument0, buffer_u16, step[@ 1]);
            buffer_write(argument0, buffer_u16, step[@ 2]);
            break;
    }
}
