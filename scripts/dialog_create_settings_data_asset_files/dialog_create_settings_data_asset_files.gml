/// @param root

var root = argument0;

var dw = 960;
var dh = 400;

var dg = dialog_create(dw, dh, "Data and Asset Files", dialog_default, dc_close_no_questions_asked, root);

var columns = 3;
var ew = dw / columns - 32 * columns;
var eh = 24;

var vx1 = ew / 3;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var spacing = 16;
var col1_x = spacing;
var col2_x = dw / columns + spacing;
var col3_x = 2 * dw / columns + spacing;

var yy = 64;
var yy_start = 64;

var el_list = create_list(col1_x, yy, "Asset Files", "", ew, eh, 8, null, false, dg, Stuff.game_asset_lists);
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

var el_types = create_list(col2_x, yy, "Contents:", "", ew, eh, 10, null, true, dg);
create_list_entries(el_types,
    ["Image: Autotiles", c_blue], ["Image: Tilesets", c_blue], ["Image: Battlers", c_blue],
    ["Image: Overworlds", c_blue], ["Image: Particles", c_blue], ["Image: UI", c_blue], ["Image: Misc.", c_blue],
    ["Audio: BGM", c_purple], ["Audio: SE", c_purple],
    ["Meshes", c_green],
    ["Maps", c_green],
    ["Data: Global", c_black], ["Data: Events", c_black], ["Data: Datadata", c_black], ["Data: Animations", c_black],
    ["Data: Terrain", c_black],
);
yy = yy + ui_get_list_height(el_types) + spacing;

yy = yy_start;

var el_name = create_input(col3_x, yy, "Name:", ew, eh, null, "", "name", validate_string, 0, 1, 12, vx1, vy1, vx2, vy2, dg);
yy = yy + el_name.height + spacing;

var el_extension = create_radio_array(col3_x, yy, "Extension:", ew, eh, null, -1, dg);
create_radio_array_options(el_extension, [Stuff.setting_asset_extension_map[0], Stuff.setting_asset_extension_map[1]]);
yy = yy + ui_get_radio_array_height(el_extension) + spacing;

var el_compressed = create_checkbox(col3_x, yy, "Compressed", ew, eh, null, false, dg);
yy = yy + el_compressed.height + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    // list
    el_list,
    el_add,
    el_remove,
    // types
    el_types,
    // specifications
    el_name,
    el_extension,
    el_compressed,
    // confirm
    el_confirm
);

return dg;