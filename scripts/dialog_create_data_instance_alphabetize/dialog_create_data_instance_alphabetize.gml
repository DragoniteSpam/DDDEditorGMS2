/// @param Dialog
function dialog_create_data_instance_alphabetize(argument0) {

    var dialog = argument0;
    var data = guid_get(dialog.root.active_type_guid);

    var dw = 480;
    var dh = 320;

    var dg = dialog_create(dw, dh, "Alphabetize", dialog_default, undefined, dialog);
    dg.data_type = data;

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var col1_x = dw * 0 / 3 + spacing;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var b_width = 128;
    var b_height = 32;

    var n_slots = 14;

    var yy = 64;
    var yy_base = yy;

    var el_text = create_text(col1_x, yy, "Do you want to alphabetize all instances of " + data.name + "? You may choose to alphabetize them by visible name or Internal Name.", ew, eh, fa_left, ew, dg);

    yy += eh + spacing;

    var el_cancel = create_button(dw / 2 - b_width - spacing, dh - 32 - b_height / 2, "Cancel", b_width, b_height, fa_center, dialog_destroy, dg, fa_center);
    var el_alphabet_name = create_button(dw / 2, dh - 32 - b_height / 2, "By Name", b_width, b_height, fa_center, uimu_data_alphabetize_name, dg, fa_center);
    var el_alphabet_internal = create_button(dw / 2 + b_width + spacing, dh - 32 - b_height / 2, "By Internal Name", b_width, b_height, fa_center, uimu_data_alphabetize_internal, dg, fa_center);

    ds_list_add(dg.contents,
        el_text,
        el_cancel,
        el_alphabet_name,
        el_alphabet_internal
    );

    return dg;


}
