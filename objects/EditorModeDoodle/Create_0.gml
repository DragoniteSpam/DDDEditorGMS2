event_inherited();

doodle_width = 640;
doodle_height = 480;
doodle_buffer = buffer_create(doodle_width * doodle_height * 4, buffer_fixed, 1);

render = editor_render_doodle;
ui = ui_init_doodle(id);
mode_id = ModeIDs.DOODLE;