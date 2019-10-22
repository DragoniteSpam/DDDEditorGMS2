/// @param UIList
/// @param xx
/// @param yy

var list = argument0;
var xx = argument1;
var yy = argument2;

var otext = list.text;
var list_data = ds_list_create();

for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
    if (Stuff.all_data[| i].type == DataTypes.DATA) {
        ds_list_add(list_data, Stuff.all_data[| i]);
    }
}

list.text = otext + string(ds_list_size(list_data));
list.entries = ds_list_sort_name_sucks(list_data);

ui_render_list(list, xx, yy);

ds_list_destroy(list_data);
list.text = otext;