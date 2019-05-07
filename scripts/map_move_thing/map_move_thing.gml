/// @description  void map_move_thing(Entity, xx, yy, zz);
/// @param Entity
/// @param  xx
/// @param  yy
/// @param  zz

// this is, if possible, even slower than map_remove_thing because it does the same
// operation and then does some extra things. please work on that.

// if the destination is not free, don't try to move, since the default
// behavior for map_add_free trying to add to an occupied location is to
// delete it
if (map_get_free_at(argument1, argument2, argument3, argument0.slot)){
    map_remove_thing(argument0);
    map_add_thing(argument0, argument1, argument2, argument3);
}
