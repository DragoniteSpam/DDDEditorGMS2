/// @param UIInput

if (script_execute(argument0.validation, argument0.value)) {
    var selection = ui_list_selection(argument0.root.el_list);

    if (selection != noone) {
        if (Stuff.setting_alphabetize_lists) {
            var list = ds_list_sort_name_sucks(Stuff.all_se);
        } else {
            var list = ds_list_create();
            ds_list_copy(list, Stuff.all_se);
        }
    
        list[| selection].name = argument0.value;
        
        ds_list_destroy(list);
    }
}