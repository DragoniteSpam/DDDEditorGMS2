/// @param buffer
/// @param Entity
/// @param version
function serialize_load_move_route(argument0, argument1, argument2) {

    var buffer = argument0;
    var entity = argument1;
    var version = argument2;

    var route = new MoveRoute(buffer_read(buffer, buffer_string));
    array_push(entity.movement_routes, route);

    buffer_read(buffer, buffer_string);
    buffer_read(buffer, buffer_u32);
    buffer_read(buffer, buffer_datatype);
    buffer_read(buffer, buffer_string);

    var bools = buffer_read(buffer, buffer_u16);

    route.repeat_action = unpack(bools, 0);
    route.skip = unpack(bools, 1);
    route.wait = unpack(bools, 2);

    var n_steps = buffer_read(buffer, buffer_u16);

    repeat (n_steps) {
        var type = buffer_read(buffer, buffer_u16);
        var data;
    
        switch (type) {
            case MoveRouteActions.MOVE_DOWN:
            case MoveRouteActions.MOVE_LEFT:
            case MoveRouteActions.MOVE_RIGHT:
            case MoveRouteActions.MOVE_UP:
            case MoveRouteActions.MOVE_LOWER_LEFT:
            case MoveRouteActions.MOVE_LOWER_RIGHT:
            case MoveRouteActions.MOVE_UPPER_LEFT:
            case MoveRouteActions.MOVE_UPPER_RIGHT:
                var ext = buffer_read(buffer, buffer_u8);
                data = [type, ext];
                break;
            case MoveRouteActions.MOVE_JUMP:
                var map = buffer_read(buffer, buffer_string);
                var xx = buffer_read(buffer, buffer_u16);
                var yy = buffer_read(buffer, buffer_u16);
                var zz = buffer_read(buffer, buffer_u16);
                var dir = buffer_read(buffer, buffer_u8);
                data = [type, map, xx, yy, zz, dir];
                break;
            case MoveRouteActions.MOVE_ACTUALLY_JUMP:
                var height = buffer_read(buffer, buffer_f32);
                data = [type, height];
                break;
            case MoveRouteActions.WAIT:
                var t = buffer_read(buffer, buffer_f32);
                data = [type, t];
                break;
            case MoveRouteActions.SWITCH_ON:
                var self_switch = buffer_read(buffer, buffer_u8);
                data = [type, self_switch];
                break;
            case MoveRouteActions.SWITCH_OFF:
                var self_switch = buffer_read(buffer, buffer_u8);
                data = [type, self_switch];
                break;
            case MoveRouteActions.CHANGE_SPEED:
                var spd = buffer_read(buffer, buffer_u8);
                data = [type, spd];
                break;
            case MoveRouteActions.CHANGE_FREQUENCY:
                var frequency = buffer_read(buffer, buffer_u8);
                data = [type, frequency];
                break;
            case MoveRouteActions.CHANGE_GRAPHIC:
                var graphic = buffer_read(buffer, buffer_datatype);
                data = [type, graphic];
                break;
            case MoveRouteActions.CHANGE_OPACITY:
                var alpha = buffer_read(buffer, buffer_f32);
                data = [type, alpha];
                break;
            case MoveRouteActions.CHANGE_TINT:
                var color = buffer_read(buffer, buffer_u8);
                data = [type, color];
                break;
            case MoveRouteActions.PLAY_SE:
                var sound = buffer_read(buffer, buffer_datatype);
                data = [type, sound];
                break;
            case MoveRouteActions.EVENT:
                var event = buffer_read(buffer, buffer_datatype);
                var entrypoint = buffer_read(buffer, buffer_datatype);
                data = [type, event, entrypoint];
                break;
            case MoveRouteActions.MOVE_TO:
                var xx = buffer_read(buffer, buffer_u16);
                var yy = buffer_read(buffer, buffer_u16);
                data = [type, xx, yy];
                break;
            default:
                data = [type];
                break;
        }
        array_push(route.steps, data);
    }


}
