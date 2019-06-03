/// @description void event_view_node(DataEventNode);
/// @param DataEventNode
// snap the view to the specified node

// this will not be called from within view_fullscreen so
// you can't use the macros
__view_set( e__VW.XView, view_fullscreen, floor(argument0.x-room_width/2) );
__view_set( e__VW.YView, view_fullscreen, floor(argument0.y-room_height/3) );
