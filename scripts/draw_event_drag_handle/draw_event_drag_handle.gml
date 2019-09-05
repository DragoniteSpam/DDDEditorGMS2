/// @param DataEventNode
/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param color

var node = argument0;
var x1 = argument1;
var y1 = argument2;
var x2 = argument3;
var y2 = argument4;
var color = argument5;

draw_roundrect_colour(x1, y1, x2, y2, color, color, false);
draw_roundrect(x1, y1, x2, y2, true);

if (!dialog_exists()) {
    // i don't like this but it works
    if (mouse_within_rectangle_adjusted(x1, y1, x2, y2) || node.offset_x > -1) {
        if (get_press_left()) {
            node.offset_x = mouse_x_view - node.x;
            node.offset_y = mouse_y_view - node.y;
        } else if (Controller.mouse_left) {
            if (node.offset_x > -1) {
                node.x = mouse_x_view - node.offset_x;
                node.y = mouse_y_view - node.offset_y;
            }
        } else {
            node.offset_x = -1;
            node.offset_y = -1;
        }
    } else {
        node.offset_x = -1;
        node.offset_y = -1;
    }
}