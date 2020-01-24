/// @param Entity
/// @param [mask]

var entity = argument[0];
var mask = (argument_count > 1) ? argument[1] : Stuff.setting_selection_mask;

if ((1 << entity.etype) & mask) {
    for (var i = 0; i < ds_list_size(Stuff.map.selection); i++) {
        if (script_execute(Stuff.map.selection[| i].selected_determination, Stuff.map.selection[| i], entity)) {
            return true;
        }
    }
}

return false;