/// @param root

var dw = 400;
var dh = 240;

var value = real(argument0.value);
    
if (value > 65535) {
    return noone;
}
    
var count = ds_list_size(Stuff.switches);
    
if (value == count) {
    return noone;
} else if (value < count) {
    return dialog_create_yes_or_no(argument0,
        "Reduce the number of global switches? Anything beyond the new limit will be lost. (If in doubt, leave it alone. The memory footprint is pretty low and there isn't really a consequence to having too many.)",
        dc_settings_switch_resize);
} else {
    for (var i = ds_list_size(Stuff.switches); i < value; i++) {
        var name = "Switch" + string(i);
        ds_list_add(Stuff.switches, [name, 0]);
        create_list_entries(argument0.root.el_list, name, c_black);
    }
        
    return noone;
}
    
return noone;