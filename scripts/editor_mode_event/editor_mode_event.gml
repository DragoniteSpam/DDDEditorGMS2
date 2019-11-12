Stuff.mode = Stuff.event;

view_set_visible(view_fullscreen, true);
view_set_visible(view_3d, false);
view_set_visible(view_ribbon, true);
view_set_visible(view_hud, true);
view_set_visible(view_3d_preview, false);

var camera = view_get_camera(view_hud);
camera_set_view_size(camera, view_hud_width_event, camera_get_view_height(camera));
view_set_xport(view_hud, room_width - view_hud_width_event);
view_set_wport(view_hud, view_hud_width_event);

var camera = view_get_camera(view_fullscreen);
camera_set_view_pos(camera, 0, 0);
camera_set_view_size(camera, room_width - view_hud_width_event, camera_get_view_height(camera));
view_set_wport(view_fullscreen, room_width - view_hud_width_event);