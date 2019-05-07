/// @description  void draw_event_node_delete(x, y, DataEventNode);
/// @param x
/// @param  y
/// @param  DataEventNode

draw_sprite(spr_event_delete, 0, argument0, argument1);

if (!dialog_exists()){
    // this is slightly less than the outbound nodes because the consequences
    // of doing it wrong are more dire
    var tolerance=8;
    if (mouse_within_rectangle_view(argument0-tolerance, argument1-tolerance, argument0+tolerance, argument1+tolerance)){
        draw_sprite(spr_event_delete, 1, argument0, argument1);
        if (get_release_left()){
            if (show_question("Delete?")){
                instance_destroy_later(argument2);
            }
        }
    }
}
