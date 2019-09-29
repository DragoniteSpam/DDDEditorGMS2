/// @param x
/// @param y
/// @param node
/// @param [index]
/// @param [terminal?]

var xx = argument[0];
var yy = argument[1];
var node = argument[2];
var index = (argument_count > 3) ? argument[3] : 0;
var terminal = (argument_count > 4) ? argument[4] : false;

draw_sprite(spr_event_outbound, terminal ? 0 : 1, xx, yy);

var tolerance = 12;

if (!dialog_exists()) {
    if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance) && Controller.press_left) {
        Camera.event_canvas_active_node = node;
        Camera.event_canvas_active_node_index = index;
    }
}