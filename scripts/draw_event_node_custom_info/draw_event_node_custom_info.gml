/// @param x
/// @param y
/// @param DataEventNode

var xx = argument0;
var yy = argument1;
var node = argument2;

draw_sprite(spr_event_info, 0, xx, yy);

if (!dialog_exists()) {
    var tolerance = 12;
    if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
        draw_sprite(spr_event_info, 1, xx, yy);
        Stuff.event_node_info = node;
    }
}