/// @param x
/// @param y
/// @param node
/// @param index
/// @param [terminal?]

var xx = argument[0];
var yy = argument[1];
var node = argument[2];
var index = argument[3];
var terminal = (argument_count > 4) ? argument[4] : false;

if (terminal) {
    draw_sprite(spr_event_outbound, 0, xx, yy);
} else {
    draw_sprite(spr_event_outbound, 1, xx, yy);
}

var tolerance = 12;

if (!dialog_exists()) {
    if (mouse_within_rectangle_view(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance) && get_press_left()) {
        Camera.event_canvas_active_node = node;
        Camera.event_canvas_active_node_index = index;
    }
}