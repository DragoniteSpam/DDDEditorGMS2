/// @param x
/// @param y
/// @param node

var xx = argument0;
var yy = argument1;
var node = argument2;

draw_sprite(spr_plus_minus, 0, xx, yy);

var tolerance = 8;
if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
    draw_sprite(spr_plus_minus, 1, xx, yy);
    draw_tooltip(xx, yy + 16, "Add Option");
    if (Controller.release_left) {
        ds_list_add(node.data, "Option " + string(ds_list_size(node.data)));
        // insert at the second to last position so that the "default" outbound node stays where it is
        ds_list_insert(node.outbound, ds_list_size(node.outbound) - 1, noone);
    }
}