/// @description  void ui_render_list_data_data_only(UIList);
/// @param UIList

var otext=argument0.text;
var oentries=argument0.entries;
var list_data=ds_list_create();

for (var i=0; i<ds_list_size(Stuff.all_data); i++){
    if (!Stuff.all_data[| i].is_enum){
        ds_list_add(list_data, Stuff.all_data[| i]);
    }
}

// this is always alphabetized
argument0.text=otext+string(ds_list_size(list_data));
argument0.entries=ds_list_sort_name_sucks(list_data);

ui_render_list(argument0, argument1, argument2);

ds_list_destroy(argument0.entries);
ds_list_destroy(list_data);

argument0.text=otext;
argument0.entries=oentries;
