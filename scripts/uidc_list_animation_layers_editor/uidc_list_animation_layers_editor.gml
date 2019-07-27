/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection >= 0) {
    var timeline_layer = list.root.active_animation.layers[| selection];
    var dw = 320;
    var dh = 160;

    var dg = dialog_create(dw, dh, "Rename Layer", undefined, undefined, argument0);
    dg.timeline_layer = timeline_layer;

    var ew = (dw - 64);
    var eh = 24;

    var vx1 = ew / 3;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;

    var b_width = 128;
    var b_height = 32;

    var el_name = create_input(16, 64, "Name:", ew, eh, uivc_animation_layer_name, 0, timeline_layer.name, "text", validate_string, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents, el_name, el_confirm);

    keyboard_string = "";
}