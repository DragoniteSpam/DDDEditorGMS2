/// @param x
/// @param y
/// @param node
/// @param index

var xx = argument0;
var yy = argument1;
var node = argument2;
var index = argument3;

draw_sprite(spr_plus_minus, 2, xx, yy);

var tolerance = 8;
if (mouse_within_rectangle_view(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
    draw_sprite(spr_plus_minus, 3, xx, yy);
    if (get_release_left()) {
        for (var i = 0; i < ds_list_size(node.custom_data); i++) {
            ds_list_delete(node.custom_data[| i], index);
        }
        
        ds_list_delete(node.ui_things, index);
        ds_list_delete(node.outbound, index);
    }
}