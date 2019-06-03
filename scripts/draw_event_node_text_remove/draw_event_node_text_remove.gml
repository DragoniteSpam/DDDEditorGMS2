/// @description void draw_event_node_text_remove(x, y, node, index);
/// @param x
/// @param y
/// @param node
/// @param index

draw_sprite(spr_plus_minus, 2, argument0, argument1);

var tolerance=8;
if (mouse_within_rectangle_view(argument0-tolerance, argument1-tolerance, argument0+tolerance, argument1+tolerance)) {
    draw_sprite(spr_plus_minus, 3, argument0, argument1);
    if (get_release_left()) {
        ds_list_delete(argument2.data, argument3);
        ds_list_delete(argument2.outbound, argument3);
    }
}
