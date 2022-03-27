/// @param x
/// @param y
/// @param node
/// @param index
function draw_event_node_choice_remove(argument0, argument1, argument2, argument3) {

    var xx = argument0;
    var yy = argument1;
    var node = argument2;
    var index = argument3;

    draw_sprite(spr_plus_minus, 2, xx, yy);

    var tolerance = 8;
    if (mouse_within_rectangle(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
        draw_sprite(spr_plus_minus, 3, xx, yy);
        draw_tooltip(xx, yy + 16, "Delete Option");
        if (Controller.release_left) {
            array_delete(node.data, index, 1);
            array_delete(node.outbound, index, 1);
        }
    }


}
