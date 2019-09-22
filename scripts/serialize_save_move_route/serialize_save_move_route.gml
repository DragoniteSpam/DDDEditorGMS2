/// @param buffer
/// @param DataMoveRoute

var buffer = argument0;
var route = argument1;

// name, guid, flags
serialize_save_generic(buffer, route);

var bools = pack(route.repeat_action, route.skip, route.wait);

buffer_write(buffer, buffer_u16, bools);

var n_steps = ds_list_size(route.steps);
buffer_write(buffer, buffer_u16, n_steps);

for (var i = 0; i < n_steps; i++) {
    var step = route.steps[| i];
    
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
            buffer_write(buffer, buffer_u32, step[@ 1]);
            break;
        case MoveRouteActions.CHANGE_OPACITY:
            buffer_write(buffer, buffer_f32, step[@ 1]);
            break;
        case MoveRouteActions.CHANGE_TINT:
            buffer_write(buffer, buffer_u8, step[@ 1]);
            break;
        case MoveRouteActions.PLAY_SE:
            buffer_write(buffer, buffer_u32, step[@ 1]);
            break;
        case MoveRouteActions.EVENT:
            buffer_write(buffer, buffer_u32, step[@ 1]);
            buffer_write(buffer, buffer_u32, step[@ 2]);
            break;
        case MoveRouteActions.MOVE_TO:
            buffer_write(buffer, buffer_u16, step[@ 1]);
            buffer_write(buffer, buffer_u16, step[@ 2]);
            break;
    }
}