/// @param UIInput

if (script_execute(argument0.validation, argument0.value)) {
    var rv = real(argument0.value);
    if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
        var selection = ui_list_selection(argument0.root.el_list);
        if (selection >= 0) {
            if (Stuff.setting_alphabetize_lists) {
                var listofthings = ds_list_sort_name_sucks(Stuff.all_bgm);
            } else {
                var listofthings = Stuff.all_bgm;
            }
        }
        
        listofthings[| selection].loop = rv;
            
        if (Stuff.setting_alphabetize_lists) {
            ds_list_destroy(listofthings);
        }
    }
}