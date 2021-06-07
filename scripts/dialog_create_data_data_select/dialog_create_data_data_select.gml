function dialog_create_data_data_select(root) {
    var dw = 320;
    var dh = 640;
    var dg = dialog_create(dw, dh, "Select Data", dialog_default, dialog_destroy, root);
    
    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var b_width = 128;
    var b_height = 32;
    
    var n_slots = 20;
    
    var yy = 64;
    
    var el_list = create_list(16, yy, "Data Types:", "<no data types>", ew, eh, n_slots, null, false, dg, []);
    for (var i = 0; i < ds_list_size(Game.data); i++) {
        if (Game.data[| i].type == DataTypes.DATA) {
            array_push(el_list.entries, Game.data[| i]);
        }
    }
    array_sort(el_list.entries, function(a, b) {
        return a.name > b.name;
    });
    el_list.entries_are = ListEntries.INSTANCES;
    
    dg.el_list_main = el_list;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_data_property_set_data, dg);
    dg.el_confirm = el_confirm;
    
    ds_list_add(dg.contents,
        el_list,
        el_confirm
    );

    return dg;
}