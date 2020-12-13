/// @param Entity
/// @param xx
/// @param yy
/// @param zz
/// @param [mark-changed?]
function map_move_thing() {

    // this is, if possible, even slower than map_remove_thing because it does the same
    // operation and then does some extra things. please work on that.

    // if the destination is not free, don't try to move, since the default
    // behavior for map_add_free trying to add to an occupied location is to
    // delete it

    var entity = argument[0];
    var xx = argument[1];
    var yy = argument[2];
    var zz = argument[3];
    var mark_changed = (argument_count > 4) ? argument[4] : true;

    if (Stuff.map.active_map.FreeAt(xx, yy, zz, entity.slot)) {
        map_remove_thing(entity);
        Stuff.map.active_map.Add(entity, xx, yy, zz, false, false);
        if (mark_changed) {
            editor_map_mark_changed(entity);
        }
    }


}
