/// @param x
/// @param y
/// @param node
/// @param index
function draw_event_node_condition_remove(argument0, argument1, argument2, argument3) {

    var xx = argument0;
    var yy = argument1;
    var node = argument2;
    var index = argument3;

    draw_sprite(spr_plus_minus, 2, xx, yy);

    var tolerance = 8;
    if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
        draw_sprite(spr_plus_minus, 3, xx, yy);
        draw_tooltip(xx, yy + 16, "Delete Data");
        if (Controller.release_left) {
            for (var i = 0; i < ds_list_size(node.custom_data); i++) {
                ds_list_delete(node.custom_data[| i], index);
            }
        
            ds_list_delete(node.ui_things, index);
            array_delete(node.outbound, index, 1);
        }
    }


}
