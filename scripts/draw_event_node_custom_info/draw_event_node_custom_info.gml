/// @description  void draw_event_node_custom_info(x, y, DataEventNode);
/// @param x
/// @param  y
/// @param  DataEventNode

draw_sprite(spr_event_info, 0, argument0, argument1);

if (!dialog_exists()){
    var tolerance=12;
    if (mouse_within_rectangle_view(argument0-tolerance, argument1-tolerance, argument0+tolerance, argument1+tolerance)){
        draw_sprite(spr_event_info, 1, argument0, argument1);
        Stuff.event_node_info=argument2;
    }
}
