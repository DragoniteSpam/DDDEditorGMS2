/// @param Dialog
/// @param node
function dialog_create_event_save_prefab(argument0, argument1) {

    var dialog = argument0;
    var node = argument1;

    var dw = 400;
    var dh = 280;

    var dg = dialog_create(dw, dh, "Save As Prefab?", dialog_note_changes, dialog_destroy, dialog);
    dg.node = node;

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var vx1 = ew / 2 - 16;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var b_width = 128;
    var b_height = 32;

    var n_slots = 10;

    var yy = 64;

    var base_name = node.name;
    var position = string_pos("$", base_name);
    if (position) {
        base_name = string_copy(base_name, 1, position - 1);
    }
    var el_name = create_input(16, yy, "Name:", ew, eh, null, base_name, "", validate_string, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    yy += el_name.height + spacing;
    dg.el_name = el_name;

    var el_nope = create_button(dw / 3, dh - 32 - b_height / 2, "Nope", b_width, b_height, fa_center, dmu_dialog_commit, dg, fa_center);
    var el_yeah = create_button(dw * 2 / 3, dh - 32 - b_height / 2, "Yeah", b_width, b_height, fa_center, dmu_dialog_event_save_prefab, dg, fa_center);

    ds_list_add(dg.contents, el_name, el_yeah, el_nope);

    return dg;


}
