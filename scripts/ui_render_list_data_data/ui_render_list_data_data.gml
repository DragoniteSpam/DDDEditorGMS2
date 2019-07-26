/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

var otext = list.text;
var oentries = list.entries;

list.text = otext + string(ds_list_size(Stuff.all_data));

if (Stuff.setting_alphabetize_lists) {
    list.entries = ds_list_sort_name_sucks(Stuff.all_data);
} else {
    list.entries = Stuff.all_data;
}

list.colorize = true;
ds_list_clear(list.entry_colors);
for (var i = 0; i < ds_list_size(list.entries); i++) {
    ds_list_add(list.entry_colors, instanceof(list.entries[| i], DataEnum) ? c_blue : c_black);
}

ui_render_list(list, xx, yy);

if (Stuff.setting_alphabetize_lists) {
    ds_list_destroy(list.entries);
}

list.text = otext;
list.entries = oentries;