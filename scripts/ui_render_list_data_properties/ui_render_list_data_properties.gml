/// @description  void ui_render_list_data_properties(UIList);
/// @param UIList

var otext=argument0.text;
var oentries=argument0.entries;

var datadata=argument0.root.selected_data;

if (datadata!=noone){
    argument0.text=otext+string(ds_list_size(datadata.properties));
    if (Stuff.setting_alphabetize_lists){
        argument0.entries=ds_list_sort_name_sucks(datadata.properties);
    } else {
        argument0.entries=datadata.properties;
    }
}

ui_render_list(argument0, argument1, argument2);

if (datadata!=noone){
    if (Stuff.setting_alphabetize_lists){
        ds_list_destroy(argument0.entries);
    }
    argument0.text=otext;
    argument0.entries=oentries;
}
