/// @param Entity

if ((1 << argument0.etype) & Camera.selection_mask) {
    for (var i = 0; i < ds_list_size(selection); i++) {
        if (script_execute(selection[| i].selected_border_determination, selection[| i], argument0)) {
            return true;
        }
    }
}

return false;