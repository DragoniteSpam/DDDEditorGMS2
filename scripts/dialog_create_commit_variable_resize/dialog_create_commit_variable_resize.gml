/// @param root
function dialog_create_commit_variable_resize(argument0) {

    var dw = 400;
    var dh = 240;

    var value = real(argument0.value);
    
    if (value > 65535) {
        return noone;
    }
    
    var count = ds_list_size(Stuff.variables);
    
    if (value == count) {
        return noone;
    }

    if (value < count) {
        return dialog_create_yes_or_no(argument0,
            "Reduce the number of global variables? Anything beyond the new limit will be lost. (If in doubt, leave it alone. The memory footprint is pretty low and there isn't really a consequence to having too many.)",
            dc_settings_variable_resize);
    }

    for (var i = ds_list_size(Stuff.variables); i < value; i++) {
        var name = "Variable" + string(i);
        ds_list_add(Stuff.variables, [name, 0]);
        create_list_entries(argument0.root.el_list, name);
    }
    
    return noone;


}
