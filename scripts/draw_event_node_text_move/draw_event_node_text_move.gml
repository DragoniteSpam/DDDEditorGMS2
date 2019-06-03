/// @description void draw_event_node_text_move(x, y, node, index, direction, image index);
/// @param x
/// @param y
/// @param node
/// @param index
/// @param direction
/// @param image index

draw_sprite(spr_scroll_arrow_enclosed, argument5, argument0, argument1);

var tolerance=8;
if (mouse_within_rectangle_view(argument0-tolerance, argument1-tolerance, argument0+tolerance, argument1+tolerance)) {
    draw_sprite(spr_scroll_arrow_enclosed, argument5+1, argument0, argument1);
    if (get_release_left()) {
        // no need to shuffle the outbound things, in this case
        var t=argument2.data[| argument3+argument4];
        argument2.data[| argument3+argument4]=argument2.data[| argument3];
        argument2.data[| argument3]=t;
    }
}
