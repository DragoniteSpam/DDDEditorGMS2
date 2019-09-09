/// @param Entity
/// @param xx
/// @param yy
/// @param zz

// this is, if possible, even slower than map_remove_thing because it does the same
// operation and then does some extra things. please work on that.

// if the destination is not free, don't try to move, since the default
// behavior for map_add_free trying to add to an occupied location is to
// delete it

var entity = argument0;
var xx = argument1;
var yy = argument2;
var zz = argument3;

if (map_get_free_at(xx, yy, zz, entity.slot)) {
    map_remove_thing(entity);
    map_add_thing(entity, xx, yy, zz);
}