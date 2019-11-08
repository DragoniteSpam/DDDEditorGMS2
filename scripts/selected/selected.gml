/// @param Entity

var entity = argument0;

if ((1 << entity.etype) & Stuff.setting_selection_mask) {
    for (var i = 0; i < ds_list_size(Stuff.map.selection); i++) {
        if (script_execute(Stuff.map.selection[| i].selected_determination, Stuff.map.selection[| i], entity)) {
            return true;
        }
    }
}

return false;