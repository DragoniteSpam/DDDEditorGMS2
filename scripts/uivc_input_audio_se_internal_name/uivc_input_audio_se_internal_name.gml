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
        
        var already = internal_name_get(argument0.value);
        if (already == noone || already == list[| selection]) {
            internal_name_remove(list[| selection].internal_name);
            internal_name_set(list[| selection], argument0.value);
            argument0.color = c_black;
        } else {
            argument0.color = c_red;
        }
        
        ds_list_destroy(list);
    }
}