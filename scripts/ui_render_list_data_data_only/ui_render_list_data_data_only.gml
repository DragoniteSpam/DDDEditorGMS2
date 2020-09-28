function ui_render_list_data_data_only(list, xx, yy) {
    var otext = list.text;
    ds_list_clear(list.entries);
    
    for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
        if (Stuff.all_data[| i].type == DataTypes.DATA) {
            ds_list_add(list.entries, Stuff.all_data[| i]);
        }
    }
    
    list.text = otext + string(ds_list_size(list.entries));
    ds_list_sort_name(list.entries);
    
    ui_render_list(list, xx, yy);
    
    list.text = otext;
}