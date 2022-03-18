event_inherited();

self.camera = new Camera(256, 256, 128, 256, 0, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
    
});
self.base_speed = 20;
self.camera.Load(setting_get("map", "camera", undefined));
self.camera.SetViewportAspect(function() {
    return Stuff.map.ui.SearchID("3D VIEWPORT").width;
}, function() {
    return Stuff.map.ui.SearchID("3D VIEWPORT").height;
});

update = function() {
    /*if (!Stuff.mouse_3d_lock && mouse_within_view(view_3d) && !dialog_exists()) {
        var map = mode.active_map;
        var map_contents = map.contents;
        control_map(mode);
    }*/
};

render = function() {
    draw_clear(EMU_COLOR_BACK);
    self.ui.Render(0, 0);
    draw_editor_menu(true);
};

cleanup = editor_cleanup_map;

save = function() {
    Settings.map.camera = self.camera.Save();
};

changes = ds_list_create();

under_cursor = noone;

selection = [];
selected_entities = ds_list_create();
last_selection = undefined;
selected_zone = noone;

selection_fill_mesh = -1;       // list index
selection_fill_tile_x = 4;
selection_fill_tile_y = 0;
selection_fill_tile_size = 32;  // make this a setting or something later
edit_z = 0;

enum SelectionModes {
    SINGLE,
    RECTANGLE,
    CIRCLE
}

enum FillTypes {
    TILE,
    TILE_ANIMATED,
    MESH,
    PAWN,
    EFFECT,
    TERRAIN,
    ZONE,
}

active_map = new DataMap("Test Map", "");
active_map.contents = new MapContents(active_map);

ui = ui_init_main(id);
mode_id = ModeIDs.MAP;
mouse_over_ui = false;