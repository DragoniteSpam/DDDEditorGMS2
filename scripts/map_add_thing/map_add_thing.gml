/// @param Entity
/// @param [xx]
/// @param [yy]
/// @param [zz]
// Does not check to see if the specified coordinates are in bounds.
// You are responsible for that.

var entity = argument[0];
var xx = (argument_count < 4) ? entity.xx : argument[1];
var yy = (argument_count < 4) ? entity.yy : argument[2];
var zz = (argument_count < 4) ? entity.zz : argument[3];
var map = Stuff.active_map.contents;

var cell = map_get_grid_cell(xx, yy, zz);

// only add thing if the space is not already occupied
if (!cell[@ entity.slot]) {
    cell[@ entity.slot] = entity;
    
    entity.xx = xx;
    entity.yy = yy;
    entity.zz = zz;
    
    if (entity.batchable) {
        ds_list_add(map.batch_in_the_future, entity);
    } else {
        ds_list_add(map.dynamic, entity);
    }
    
    ds_list_add(map.all_entities, entity);
    
    map_transform_thing(entity);
    
    entity.listed = true;
    
    ds_list_add(Camera.changes, entity);
} else {
    safa_delete(entity);
}