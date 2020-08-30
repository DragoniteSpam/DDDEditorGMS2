function editor_map_mark_changed(entity) {
    if (entity.modification == Modifications.NONE) {
        entity.modification = Modifications.UPDATE;
        ds_list_add(Stuff.map.changes, entity);
    }
}