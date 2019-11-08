/// @param Entity

var entity = argument0;

if ((1 << entity.etype) & Stuff.setting_selection_mask) {
    for (var i = 0; i < ds_list_size(selection); i++) {
        if (script_execute(selection[| i].selected_border_determination, selection[| i], entity)) {
            return true;
        }
    }
}

return false;