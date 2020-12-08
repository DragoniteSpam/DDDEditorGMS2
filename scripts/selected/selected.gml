/// @param Entity
/// @param [mask]
function selected() {

    var entity = argument[0];
    var mask = (argument_count > 1) ? argument[1] : Settings.selection.mask;

    if (!entity.exist_in_map) {
        return false;
    }

    if (entity.etype_flags & mask) {
        for (var i = 0; i < ds_list_size(Stuff.map.selection); i++) {
            if (Stuff.map.selection[| i].selected_determination(entity)) {
                return true;
            }
        }
    }

    return false;


}
