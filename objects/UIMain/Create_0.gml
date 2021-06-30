event_inherited();

render = ui_render_main;
root = id;

element_height = 24;
home_row_y = 96;

tabs = ds_list_create();

active_tab = noone;

GetLegalWidth = function() {
    var camera = view_get_camera(view_hud);
    return camera_get_view_width(camera) - 64;
};

GetLegalHeight = function() {
    var camera = view_get_camera(view_hud);
    return camera_get_view_height(camera) - self.home_row_y - 32;
};