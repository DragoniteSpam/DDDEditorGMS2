/// @description void draw_event_node_text_add(x, y, node);
/// @param x
/// @param y
/// @param node

draw_sprite(spr_plus_minus, 0, argument0, argument1);

var tolerance=8;
if (mouse_within_rectangle_view(argument0-tolerance, argument1-tolerance, argument0+tolerance, argument1+tolerance)) {
    draw_sprite(spr_plus_minus, 1, argument0, argument1);
    if (get_release_left()) {
        ds_list_add(argument2.data, "Text line "+string(ds_list_size(argument2.data)));
        ds_list_add(argument2.outbound, noone);
    }
}
