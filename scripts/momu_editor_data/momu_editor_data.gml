/// @param MenuElement

var element = argument0;

Camera.mode = EditorModes.EDITOR_DATA;

view_set_visible(view_fullscreen, true);
view_set_visible(view_3d, false);
view_set_visible(view_ribbon, true);
view_set_visible(view_hud, false);
view_set_visible(view_3d_preview, false);

var camera = view_get_camera(view_fullscreen);
camera_set_view_pos(camera, 0, 0);
camera_set_view_size(camera, room_width, camera_get_view_height(camera));
view_set_wport(view_fullscreen, room_width);

menu_activate(noone);

// this may need to get stuffed off into its own script later

if (Camera.ui_game_data) {
    instance_activate_object(Camera.ui_game_data);
    instance_destroy(Camera.ui_game_data);
}

Camera.ui_game_data = ui_init_game_data();

if (ds_list_size(Stuff.all_data) > 0) {
    ds_map_add(Camera.ui_game_data.el_master.selected_entries, 0, true);
}

ui_init_game_data_activate();