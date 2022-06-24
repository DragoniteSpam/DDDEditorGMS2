event_inherited();

render = ui_render_main;
root = id;

element_height = 24;
home_row_y = 96;

tabs = ds_list_create();

active_tab = noone;

GetLegalWidth = function() {
    return window_get_width() - 64;
};

GetLegalHeight = function() {
    return window_get_width() - self.home_row_y - 32;
};