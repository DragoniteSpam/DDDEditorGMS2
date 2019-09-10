/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

var otext = list.text;

list.text = otext + string(ds_list_size(Stuff.all_data));
list.entries = Stuff.all_data;

list.colorize = true;
ds_list_clear(list.entry_colors);
for (var i = 0; i < ds_list_size(list.entries); i++) {
    ds_list_add(list.entry_colors, instanceof(list.entries[| i], DataEnum) ? c_blue : c_black);
}

ui_render_list(list, xx, yy);

list.text = otext;