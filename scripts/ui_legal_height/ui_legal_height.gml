/// @param UI

var ui = argument[0];

var camera = view_get_camera(view_hud);
return camera_get_view_height(camera) - ui.home_row_y - 32;