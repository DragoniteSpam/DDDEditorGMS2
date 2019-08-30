/// @param MenuElement

var catch = argument0;

Camera.mode = EditorModes.EDITOR_ANIMATION;

view_set_visible(view_fullscreen, true);
view_set_visible(view_3d, true);
view_set_visible(view_ribbon, true);
view_set_visible(view_hud, false);
view_set_visible(view_3d_preview, false);

var camera = view_get_camera(view_fullscreen);
camera_set_view_pos(camera, 0, 0);
camera_set_view_size(camera, room_width, camera_get_view_height(camera));
view_set_wport(view_fullscreen, room_width);

// hard-coding this will SEVERELY screw up the whole deal with allowing the window to be
// resized, but i'll deal with that when i have to
var camera = view_get_camera(view_3d);
camera_set_view_pos(camera, 0, 0);
view_set_xport(view_3d, 576);
view_set_yport(view_3d, 336);
view_set_wport(view_3d, room_width - 32 - 576);
view_set_hport(view_3d, room_height - 32 - 336);

menu_activate(noone);