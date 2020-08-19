/// @param Entity
function editor_map_mark_changed(argument0) {

    var entity = argument0;

    if (entity.modification == Modifications.NONE) {
        entity.modification = Modifications.UPDATE;
        ds_list_add(Stuff.map.changes, entity);
    }


}
