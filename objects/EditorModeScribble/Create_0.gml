event_inherited();

scribble_init("data\\fonts", "FDefault", true);
scribble_colours = ds_map_to_list(global.__scribble_colours);
ds_list_sort(scribble_colours, true);
scribble_fonts = ds_map_to_list(global.__scribble_font_data);
ds_list_sort(scribble_fonts, true);

scribble = noone;
scribble_text = "Type something here to be previewed in [wave][rainbow]Scribble[]!\n\n(This isn't a real text editor, and you can't select text or use the arrow keys or anything, but you can use the Copy and Paste buttons if you find that makes writing the text you want to preview to be easier.)";
scribble_text_time = 0;
scribble_bounds_width = 1;
scribble_bounds_width_min = 0.25;
scribble_bounds_width_max = 1;
scribble_default_colour = c_black;

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

scribble_back_show_grid = true;
scribble_back_colour = c_white;

render = editor_render_scribble;
ui = ui_init_scribble(id);
mode_id = ModeIDs.SCRIBBLE;