event_inherited();

scribble_init("data\\fonts", "FDefault12", true);
scribble_colors = ds_map_to_list(global.__scribble_colours);

scribble = noone;
scribble_text = "Type something here to be previewed in [wave][rainbow]Scribble[]!";
scribble_text_time = 0;
scribble_bounds_width = 1;
scribble_bounds_width_min = 0.25;
scribble_bounds_width_max = 1;

scribble_autotype_in_method = SCRIBBLE_AUTOTYPE_NONE;
scribble_autotype_out_method = SCRIBBLE_AUTOTYPE_NONE;
scribble_autotype_in_speed = 1;
scribble_autotype_out_speed = 1;
scribble_autotype_in_smoothness = 1;
scribble_autotype_out_smoothness = 1;
scribble_autotype_in_delay = 4;
scribble_autotype_out_delay = 0.5;
scribble_autotype_completion_time = 0;
scribble_autotype_in = -1;

render = editor_render_scribble;
ui = ui_init_scribble(id);
mode_id = ModeIDs.SCRIBBLE;