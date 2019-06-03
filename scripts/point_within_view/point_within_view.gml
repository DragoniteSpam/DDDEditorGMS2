/// @description boolean point_within_view(view, x, y);
/// @param view
/// @param x
/// @param y

return point_in_rectangle(argument1, argument2,
    __view_get( e__VW.XPort, argument0 ), __view_get( e__VW.YPort, argument0 ),
    __view_get( e__VW.XPort, argument0 )+__view_get( e__VW.WPort, argument0 ),
    __view_get( e__VW.YPort, argument0 )+__view_get( e__VW.HPort, argument0 ));
