/// @param UIList

var otext = argument0.text;
var oentries = argument0.entries;

argument0.text = otext + string(ds_list_size(Stuff.all_data));

if (Stuff.setting_alphabetize_lists) {
    argument0.entries = ds_list_sort_name_sucks(Stuff.all_data);
} else {
    argument0.entries = Stuff.all_data;
}

argument0.colorize = true;
ds_list_clear(argument0.entry_colors);
for (var i = 0; i < ds_list_size(argument0.entries); i++) {
    ds_list_add(argument0.entry_colors, instanceof(argument0.entries[| i], DataEnum) ? c_blue : c_black);
}

ui_render_list(argument0, argument1, argument2);

if (Stuff.setting_alphabetize_lists) {
    ds_list_destroy(argument0.entries);
}

argument0.text = otext;
argument0.entries = oentries;
