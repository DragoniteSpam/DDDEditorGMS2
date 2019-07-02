/// @param MenuElement

var catch = argument0;

Camera.mode = EditorModes.EDITOR_DATA;

__view_set( e__VW.Visible, view_fullscreen, true );
__view_set( e__VW.Visible, view_3d, false );
__view_set( e__VW.Visible, view_ribbon, true );
__view_set( e__VW.Visible, view_hud, false );
__view_set( e__VW.Visible, view_3d_preview, false );

__view_set( e__VW.WView, view_fullscreen, room_width );
__view_set( e__VW.WPort, view_fullscreen, room_width );
__view_set( e__VW.XView, view_fullscreen, 0 );
__view_set( e__VW.YView, view_fullscreen, 0 );

menu_activate(noone);

// this may need to get stuffed off into its own script later

if (Camera.ui_game_data != noone) {
    instance_activate_object(Camera.ui_game_data);
    instance_destroy(Camera.ui_game_data);
}

Camera.ui_game_data = ui_init_game_data();

if (ds_list_size(Stuff.all_data) > 0) {
    ds_map_add(Camera.ui_game_data.el_master.selected_entries, 0, true);
}

ui_init_game_data_activate();