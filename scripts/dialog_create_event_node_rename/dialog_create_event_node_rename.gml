/// @param node
function dialog_create_event_node_rename(argument0) {

    var node = argument0;

    var dw = 400;
    var dh = 200;

    var dg = dialog_create(dw, dh, "Rename Node", dialog_default, undefined, noone);
    dg.node = node;
    dg.suffix = "";
    for (var i = string_length(node.name); i > 0; i--) {
        var c = string_char_at(node.name, i);
        dg.suffix = c + dg.suffix;
        if (c == "$") break;
    }
    var name_text = string_copy(node.name, 1, i - 1);

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

    var yy = 64;
    var yy_base = yy;

    var el_input = create_input(col1_x, yy, "Name:", ew, eh, uivc_event_attain_node_name, name_text, "", validate_string_event_name, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    yy += el_input.height;

    var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dialog_destroy, dg, fa_center);

    ds_list_add(dg.contents,
        el_input,
        el_confirm,
    );

    return dg;


}
