/// @param Dialog

var dw = 540;
var dh = 400;

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
var yy = 96;
var mbw = 64;
var mbh = eh;

dg.buttons = array_create(array_length_1d(ActiveMap.mesh_autotiles));
array_clear(dg.buttons, noone);

for (var i = 0; i < array_length_1d(ActiveMap.mesh_autotiles); i++) {
    var button = create_button(xx, yy, "AT" + string(i), mbw, mbh, fa_center, dmu_dialog_load_mesh_autotile, dg);
    button.color = (ActiveMap.mesh_autotiles[i] == noone) ? c_gray : c_black;
    button.key = i;
    yy = yy + button.height + spacing;
    if (yy > dh - (eh + spacing) * 2) {
        xx = xx + mbw;
        yy = 96;
    }
    ds_list_add(dg.contents, button);
    dg.buttons[i] = button;
}

dg.el_preview = create_button(dw / 2 - b_width - 32, dh - 32 - b_height / 2, "Preview", b_width, b_height, fa_center, dmu_dialog_preview_mesh, dg);
dg.el_preview.interactive = false;

var el_confirm = create_button(dw / 2 + 32, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, dg.el_preview, el_confirm);

keyboard_string = "";

return dg;