/// @param Dialog

var dw = 540;
var dh = 640;

var dg = dialog_create(dw, dh, "Data: Mesh Autotiles", dialog_default, dc_manager_mesh, argument0);

var ew = (dw - 64) / 2;
var eh = 24;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var spacing = 16;

var xx = 16;
var yy = 64;
var yy_start = yy;
var mbw = 64 - spacing;
var mbh = eh;

dg.buttons = array_create(array_length_1d(ActiveMap.mesh_autotiles));
dg.icons = array_create(array_length_1d(ActiveMap.mesh_autotiles));
array_clear(dg.buttons, noone);

for (var i = 0; i < array_length_1d(ActiveMap.mesh_autotiles); i++) {
    var button = create_button(xx, yy, string(i), mbw, mbh, fa_center, dmu_dialog_load_mesh_autotile, dg);
    button.color = (ActiveMap.mesh_autotiles[i] == noone) ? c_gray : c_black;
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

dg.el_load = create_button(dw / 4 - b_width / 2, dh - 32 - b_height / 2, "Load", b_width, b_height, fa_center, null, dg);
dg.el_save = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Save", b_width, b_height, fa_center, null, dg);

var el_confirm = create_button(dw * 3 / 4 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, dg.el_load, dg.el_save, el_confirm);

keyboard_string = "";

return dg;