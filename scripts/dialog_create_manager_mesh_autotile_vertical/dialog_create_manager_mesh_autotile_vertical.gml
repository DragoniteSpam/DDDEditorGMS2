/// @param root

var root = argument0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

var dw = 800;
var dh = 480;

var dg = dialog_create(dw, dh, "Data: Mesh Autotiles (Vertical)", undefined, undefined, root);

var ew = (dw - 64) / 2;
var eh = 24;

var b_width = 128;
var b_height = 32;

var spacing = 16;

var xx = 16;
var yy = 64;
var xx_start = xx;
var mbw = 64 - spacing;
var mbh = eh;
var columns = 12;

dg.buttons = array_create(array_length_1d(map_contents.mesh_autotiles_vertical));
dg.icons = array_create(array_length_1d(map_contents.mesh_autotiles_vertical));
array_clear(dg.buttons, noone);

for (var i = 0; i < array_length_1d(map_contents.mesh_autotiles_vertical); i++) {
    var button = create_button(xx, yy, string(i), mbw, mbh, fa_center, dmu_dialog_load_mesh_autotile_vertical, dg);
    button.tooltip = "Import a mesh for vertical mesh autotile #" + string(i) + ". It should take the shape of the icon below, with green representing the outer part and brown representing the inner part.";
    button.color = map_contents.mesh_autotiles_vertical[i] ? c_black : c_gray;
    button.key = i;
    ds_list_add(dg.contents, button);
    dg.buttons[i] = button;
    
    var icon = create_image_button(xx + spacing / 2, yy + button.height + spacing, "b", spr_autotile_blueprint, 32, 32, fa_center, null, dg);
    icon.index = i;
    icon.outline = false;
    icon.interactive = false;
    
    xx = xx + mbw + spacing;
    
    if (i % columns == columns - 1) {
        xx = xx_start;
        yy += mbh + icon.height + spacing * 2;
    }
    
    ds_list_add(dg.contents, icon);
    dg.icon[i] = icon;
}

var el_import_series = create_button(dw / 4 - b_width / 2, dh - 32 - b_height / 2, "Import Batch", b_width, b_height, fa_center, dmu_dialog_mesh_autotile_import_batch_vertical, dg);
el_import_series.tooltip = "Import autotile meshes in batch. If you want to load an entire series at once you should probably choose this option, because selecting them one-by-one would be very slow.";
var el_clear = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Clear All", b_width, b_height, fa_center, dmu_dialog_mesh_autotile_remove_all_vertical, dg);
el_clear.tooltip = "Removes all imported mesh autotiles. Entities which use them will continue to exist, but will be invisible."
var el_confirm = create_button(dw * 3 / 4 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_import_series,
    el_clear,
    el_confirm
);

return dg;