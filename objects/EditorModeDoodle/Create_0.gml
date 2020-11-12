event_inherited();

doodle_width = 1;
doodle_height = 1;
doodle_buffer = -1;

doodle_tool = DoodleTools.FLOODFILL;
doodle_color_a = c_black;
doodle_color_b = c_white;
doodle_color_alpha = 1;

doodle_brush_size = 4;

render = function() {
    switch (view_current) {
        case view_ribbon: draw_editor_menu(); break;
        case view_fullscreen: draw_editor_fullscreen(); break;
    }
};
ui = ui_init_doodle(id);
mode_id = ModeIDs.DOODLE;

enum DoodleTools {
    PENCIL,
    FLOODFILL,
}