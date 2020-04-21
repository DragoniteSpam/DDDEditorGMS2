event_inherited();

doodle_width = 1;
doodle_height = 1;
doodle_buffer = -1;

doodle_tool = DoodleTools.PENCIL;
doodle_color_a = c_black;
doodle_color_b = c_white;
doodle_color_alpha = 1;
doodle_brush_size = 4;

render = editor_render_doodle;
ui = ui_init_doodle(id);
mode_id = ModeIDs.DOODLE;

enum DoodleTools {
    PENCIL,
}