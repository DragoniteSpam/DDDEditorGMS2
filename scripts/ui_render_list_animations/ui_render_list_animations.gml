/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

var otext = list.text;
var oentries = list.entries;

list.text = otext + string(ds_list_size(Stuff.all_animations));

if (Stuff.setting_alphabetize_lists) {
    list.entries = ds_list_sort_name_sucks(Stuff.all_animations);
} else {
    list.entries = Stuff.all_animations;
}

ui_render_list(list, xx, yy);

if (Stuff.setting_alphabetize_lists) {
    ds_list_destroy(list.entries);
}

list.text = otext;
list.entries = oentries;