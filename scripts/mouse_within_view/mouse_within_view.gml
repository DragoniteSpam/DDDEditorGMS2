/// @description boolean mouse_within_view(view);
/// @param view

return point_in_rectangle(Camera.MOUSE_X, Camera.MOUSE_Y,
    __view_get( e__VW.XPort, argument0 ), __view_get( e__VW.YPort, argument0 ),
    __view_get( e__VW.XPort, argument0 )+__view_get( e__VW.WPort, argument0 ),
    __view_get( e__VW.YPort, argument0 )+__view_get( e__VW.HPort, argument0 ));
