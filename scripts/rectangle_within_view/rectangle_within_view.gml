/// @description boolean rectangle_within_view(view, x1, y1, x2, y2);
/// @param view
/// @param x1
/// @param y1
/// @param x2
/// @param y2

return rectangle_in_rectangle(argument1, argument2, argument3, argument4,
    __view_get( e__VW.XView, argument0 ), __view_get( e__VW.YView, argument0 ),
    __view_get( e__VW.XView, argument0 )+__view_get( e__VW.WView, argument0 ),
    __view_get( e__VW.YView, argument0 )+__view_get( e__VW.HView, argument0 ));
