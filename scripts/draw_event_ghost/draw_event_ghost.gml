/// @param x
/// @param y
/// @param x2
/// @param y2
/// @param outbound

var xx = argument0;
var yy = argument1;
var half_height = 16;
var x1 = argument2;
var y1 = argument3 - half_height;
var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
var y2 = argument3 + half_height;
var outbound = argument4;
var padding = 4;

draw_roundrect_colour(x1, y1, x2, y2, c_ev_ghost, c_ev_ghost, false);
draw_roundrect(x1, y1, x2, y2, true);

var c = colour_mute(c_ev_ghost);
if (mouse_within_rectangle_adjusted(x1, y1, x2, y2)) {
    draw_roundrect_colour(x1 + padding, y1 + padding, x2 - padding, y2 - padding, c, c, false);
    if (!dialog_exists()) {
        if (Controller.release_left) {
            event_view_node(outbound);
        }
    }
}

draw_text(x1 + 16, mean(y1, y2), string(outbound.name));
// this is sort of a bezier but not really
draw_line(xx, yy, x1, mean(y1, y2));