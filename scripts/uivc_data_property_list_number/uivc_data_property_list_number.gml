/// @param UIInput

if (script_execute(argument0.validation, argument0.value)) {
    var rv = real(argument0.value);
    if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
        var selection = ui_list_selection(Camera.ui_game_data.el_instances);
        var pselection = ui_list_selection(argument0.root.el_list_main);
        
        if (pselection >= 0) {
            var data = guid_get(Camera.ui_game_data.active_type_guid);
            var instance = guid_get(data.instances[| selection].GUID);
            var plist = instance.values[| argument0.key];
            
            plist[| pselection] = rv;
            
            argument0.root.el_list_main.entries[| pselection] = string(rv);
        }
    }
}