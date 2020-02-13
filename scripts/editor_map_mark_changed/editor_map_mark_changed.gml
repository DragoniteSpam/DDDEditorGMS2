/// @param Entity

var entity = argument0;

if (entity.modification != Modifications.NONE) {
    entity.modification = Modifications.UPDATE;
    ds_list_add(Stuff.map.changes, entity);
}