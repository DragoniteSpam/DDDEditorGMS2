/// @param x
/// @param y
/// @param node
/// @param index
/// @param [terminal?]

if (argument_count == 5 && argument[4]) {
    draw_sprite(spr_event_outbound, 0, argument[0], argument[1]);
} else {
    draw_sprite(spr_event_outbound, 1, argument[0], argument[1]);
}

var tolerance = 12;

if (!dialog_exists()) {
    if (mouse_within_rectangle_view(argument[0] - tolerance, argument[1] - tolerance, argument[0] + tolerance, argument[1] + tolerance) && get_press_left()) {
        Camera.event_canvas_active_node = argument[2];
        Camera.event_canvas_active_node_index = argument[3];
    }
}