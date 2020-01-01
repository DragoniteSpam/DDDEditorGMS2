/// @param root

var root = argument0;

var dw = 640;
var dh = 640;

var dg = dialog_create(dw, dh, "Data and Asset Files", dialog_default, dc_close_no_questions_asked, root);

var columns = 2;
var ew = dw / columns - 32 * columns;
var eh = 24;

var vx1 = ew / 2 + 16;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var spacing = 16;
var col1_x = spacing;
var col2_x = dw / columns + spacing;

var yy = 64;
var yy_start = 64;

var el_list = create_list(col1_x, yy, "Asset Files", "", ew, eh, 16, null, false, dg, Stuff.game_asset_lists);
el_list.entries_are = ListEntries.SCRIPT;
el_list.evaluate_text = ui_list_text_asset_files;
el_list.render_colors = ui_list_colors_asset_files;
dg.el_list = el_list;
yy = yy + ui_get_list_height(el_list) + spacing;

var el_add = create_button(col1_x, yy, "Add Asset File", ew, eh, fa_center, null, dg);
yy = yy + el_add.height + spacing;

var el_remove = create_button(col1_x, yy, "Remove Asset File", ew, eh, fa_center, null, dg);
yy = yy + el_remove.height + spacing;

yy = yy_start;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list,
    el_add,
    el_remove,
    el_confirm
);

return dg;