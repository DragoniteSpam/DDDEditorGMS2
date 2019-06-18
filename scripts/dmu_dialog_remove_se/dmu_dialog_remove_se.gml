/// @param UIThing

var selection = ui_list_selection(argument0.root.el_list);

if (selection != noone) {
    if (Stuff.setting_alphabetize_lists) {
        var list = ds_list_sort_name_sucks(Stuff.all_se);
    } else {
        var list = ds_list_create();
        ds_list_copy(list, Stuff.all_se);
    }
    
    audio_remove_se(list[| selection].GUID);
    ui_list_deselect(argument0.root.el_list);
    
    ds_list_destroy(list);
}