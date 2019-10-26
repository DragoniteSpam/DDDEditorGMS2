/// @param Dialog

var dialog = argument0;

var dw = 640;
var dh = 640;

var dg = dialog_create(dw, dh, "New Map", undefined, undefined, dialog);

var ew = (dw - 64) / 2;
var eh = 24;
var spacing = 16;

var c2 = dw / 2 + 16;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;
var yy_base = 64;

var el_heading = create_text(32, yy, "Map Settings", ew, eh, fa_left, ew, dg);

yy = yy + el_heading.height + spacing;

var el_grid = create_checkbox(32, yy, "Aligned to Grid?", ew, eh, null, 0, true, dg);
dg.el_grid = el_grid;

yy = yy + el_grid.height + spacing;

var el_x = create_input(32, yy, "Width (X):", ew, eh, null, 0, 64, "", validate_int_create_map_size_x, ui_value_real, 0, 1, 5, vx1, vy1, vx2, vy2, dg);
dg.el_x = el_x;

yy = yy + el_x.height + spacing;

var el_y = create_input(32, yy, "Height (Y):", ew, eh, null, 0, 64, "", validate_int, ui_value_real, 0, 1, 5, vx1, vy1, vx2, vy2, dg);
dg.el_y = el_y;

yy = yy + el_y.height + spacing;

var el_z = create_input(32, yy, "Depth (Z):", ew, eh, null, 0, 64, "", validate_int, ui_value_real, 0, 1, 5, vx1, vy1, vx2, vy2, dg);
dg.el_z = el_y;

yy = yy + el_z.height + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Okay", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_heading,
    el_grid, el_x, el_y, el_z,
    el_confirm
);

return dg;