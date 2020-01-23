/// @param root

var root = argument0;
var map = Stuff.map.active_map.contents;

var dw = 540;
var dh = 640;

var dg = dialog_create(dw, dh, "Data: Mesh Autotiles", undefined, undefined, root);

var ew = (dw - 64) / 2;
var eh = 24;

var b_width = 128;
var b_height = 32;

var spacing = 16;

var xx = 16;
var yy = 64;
var yy_start = yy;
var mbw = 64 - spacing;
var mbh = eh;

dg.buttons = array_create(array_length_1d(map.mesh_autotiles));
dg.icons = array_create(array_length_1d(map.mesh_autotiles));
array_clear(dg.buttons, noone);

for (var i = 0; i < array_length_1d(map.mesh_autotiles); i++) {
    var button = create_button(xx, yy, string(i), mbw, mbh, fa_center, dmu_dialog_load_mesh_autotile, dg);
    button.color = map.mesh_autotiles[i] ? c_black : c_gray;
    button.key = i;
    ds_list_add(dg.contents, button);
    dg.buttons[i] = button;
    
    yy = yy + button.height + spacing;
    
    var icon = create_image_button(xx + spacing / 2, yy, "b", spr_autotile_blueprint, 32, 32, fa_center, null, dg);
    icon.index = i;
    icon.outline = false;
    icon.interactive = false;
    
    yy = yy + icon.height + spacing;
    
    if (yy > dh - (eh + spacing) * 2) {
        xx = xx + mbw + spacing;
        yy = yy_start;
    }
    
    ds_list_add(dg.contents, icon);
    dg.icon[i] = icon;
}

dg.el_load = create_button(dw / 4 - b_width / 2, dh - 32 - b_height / 2, "Import", b_width, b_height, fa_center, dmu_dialog_mesh_autotile_import, dg);
dg.el_save = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Export", b_width, b_height, fa_center, dmu_dialog_mesh_autotile_export, dg);

var el_confirm = create_button(dw * 3 / 4 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, dg.el_load, dg.el_save, el_confirm);

return dg;