/// @param Dialog

var dialog = argument0;

var dw = 960;
var dh = 640;

var dg = dialog_create(dw, dh, "Map Settings", dialog_default, dc_settings_map, dialog);

// three columns!
var ew = (dw - 96) / 3;
var eh = 24;

var c2 = dw / 3;
var c3 = dw * 2 / 3;

var vx1 = dw / 6 + 16;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var vx2 = dw - 32;

var el_name_text = create_text(16, yy, "Settings: Text", ew, eh, fa_left, ew, dg);
yy = yy + 32;
var el_name = create_input(16, yy, "Name: ", ew, eh, uivc_settings_map_name, "", ActiveMap.name, "Map name goes here", validate_string, ui_value_string, 0, 0, 32, vx1, vy1, vx2, vy2, dg);
yy = yy + 32;
var el_name_internal = create_input(16, yy, "Internal name: ", ew, eh, uivc_settings_map_internal, "", ActiveMap.internal_name, "[A-Za-z0-9_]+", validate_string_internal_name, ui_value_string, 0, 0, 32, vx1, vy1, vx2, vy2, dg);

yy = yy + 32;

var eh_long = 120;
var vy2 = vy1 + eh_long;

var el_summary = create_input(16, yy, "Summary: ", ew, eh_long, uivc_settings_map_summary, "", ActiveMap.summary, "Write a summary here", validate_string, ui_value_string, 0, 0, 400, vx1, vy1, vx2, vy2, dg);

var vx2 = ew;
var vy2 = vy1 + eh;

var yy_column_start = yy + eh_long + 32;
yy = yy_column_start;
var el_dim_text = create_text(16, yy, "Settings: Dimensions", ew, eh, fa_left, ew, dg);
yy = yy + 32;
var el_width = create_input(16, yy, "Map Width (X): ", ew, eh, uivc_stash, "x", ActiveMap.xx, "64", validate_int, ui_value_real, 1, MAP_X_LIMIT, 4, vx1, vy1, vx2, vy2, dg);
yy = yy + 32;
var el_height = create_input(16, yy, "Map Height (Y): ", ew, eh, uivc_stash, "y", ActiveMap.yy, "64", validate_int, ui_value_real, 1, MAP_Y_LIMIT, 4, vx1, vy1, vx2, vy2, dg);
yy = yy + 32;
var el_depth = create_input(16, yy, "Map Depth (Z): ", ew, eh, uivc_stash, "z", ActiveMap.zz, "8", validate_int, ui_value_real, 1, MAP_Y_LIMIT, 4, vx1, vy1, vx2, vy2, dg);

yy = yy_column_start;
var el_other = create_text(c2, yy, "Settings: Other", ew, eh, fa_left, ew, dg);
yy = yy + 32;
var el_other_3d = create_checkbox(c2, yy, "Is 3D?", ew, eh, uivc_settings_map_3d, "", ActiveMap.is_3d, dg);
yy = yy + 32;
var el_other_fog_start = create_input(c2, yy, "3D Fog Start: ", ew, eh, uivc_settings_map_fog_start, "", ActiveMap.fog_start, "256", validate_int, ui_value_real, 1, (1 << 16) - 1, 5, vx1, vy1, vx2, vy2, dg);
el_other_fog_start.interactive = ActiveMap.is_3d;
dg.el_other_fog_start = el_other_fog_start;
yy = yy + 32;
var el_other_fog_end = create_input(c2, yy, "3D Fog End: ", ew, eh, uivc_settings_map_fog_end, "", ActiveMap.fog_end, "1024", validate_int, ui_value_real, 1, (1 << 16) - 1, 5, vx1, vy1, vx2, vy2, dg);
el_other_fog_end.interactive = ActiveMap.is_3d;
dg.el_other_fog_end = el_other_fog_end;
yy = yy + 32;
var el_other_indoors = create_checkbox(c2, yy, "Is indoors?", ew, eh, uivc_settings_map_indoors, "", ActiveMap.indoors, dg);
yy = yy + 32;
var el_other_water = create_checkbox(c2, yy, "Render water?", ew, eh, uivc_settings_map_water, "", ActiveMap.draw_water, dg);
yy = yy + 32;
var el_other_fast_travel_to = create_checkbox(c2, yy, "Can fast travel to?", ew, eh, uivc_settings_map_fast_travel_to, "", ActiveMap.fast_travel_to, dg);
yy = yy + 32;
var el_other_fast_travel_from = create_checkbox(c2, yy, "Can fast travel from?", ew, eh, uivc_settings_map_fast_travel_from, "", ActiveMap.fast_travel_from, dg);

yy = yy_column_start;
var el_code_heading = create_text(c3, yy, "Update Code", ew, eh, fa_left, ew, dg);
yy = yy + 32;
var el_code = create_input_code(c3, yy, "", ew, eh, 0, vy1, vx2, vy2, ActiveMap.code, uivc_map_code, dg);

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_name_text, el_name, el_name_internal, el_summary,
    el_dim_text, el_width, el_height, el_depth,
    el_other, el_other_3d, el_other_fog_start, el_other_fog_end, el_other_indoors, el_other_water, el_other_fast_travel_to, el_other_fast_travel_from,
    el_code_heading, el_code,
    el_confirm);

keyboard_string = "";

return dg;