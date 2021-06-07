/// @param Dialog
function dialog_create_data_enum_select(argument0) {

    var root = argument0;

    var dw = 320;
    var dh = 640;

    var dg = dialog_create(dw, dh, "Select Enum", dialog_default, dialog_destroy, root);

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var vx1 = dw / (columns * 2) - 16;
    var vy1 = 0;
    var vx2 = vx1 + dw / (columns * 2) - 16;
    var vy2 = eh;

    var b_width = 128;
    var b_height = 32;

    var n_slots = 20;

    var yy = 64;

    var el_list = create_list(16, yy, "Enums:", "<no enums>", ew, eh, n_slots, null, false, dg);
    for (var i = 0; i < array_length(Game.data); i++) {
        if (Game.data[i].type == DataTypes.ENUM) {
            array_push(el_list.entries, Game.data[i]);
        }
    }
    array_sort(el_list.entries, function(a, b) {
        return a.name > b.name;
    });
    el_list.entries_are = ListEntries.INSTANCES;

    dg.el_list_main = el_list;

    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_data_property_set_enum, dg);
    dg.el_confirm = el_confirm;

    ds_list_add(dg.contents,
        el_list,
        el_confirm
    );

    return dg;


}
