/// @param Entity
/// @param [xx]
/// @param [yy]
/// @param [zz]
/// @param [map]
/// @param [is_temp]
// Does not check to see if the specified coordinates are in bounds.
// You are responsible for that.

var entity = argument[0];
var xx = (argument_count < 4) ? entity.xx : argument[1];
var yy = (argument_count < 4) ? entity.yy : argument[2];
var zz = (argument_count < 4) ? entity.zz : argument[3];
var map_container = (argument_count > 4) ? argument[4] : Stuff.active_map;
var is_temp = (argument_count > 5) ? argument[5] : false;
var map = map_container.contents;

var cell = map_get_grid_cell(xx, yy, zz, map_container);

// only add thing if the space is not already occupied
if (!cell[@ entity.slot]) {
    cell[@ entity.slot] = entity;
    
    entity.xx = xx;
    entity.yy = yy;
    entity.zz = zz;
    
    map_transform_thing(entity);
    ds_list_add(map.all_entities, entity);
	
	if (!is_temp) {
		ds_list_add(entity.batchable ? map.batch_in_the_future : map.dynamic, entity);
		
	    entity.listed = true;
	    ds_list_add(Camera.changes, entity);
	}
} else {
    safa_delete(entity);
}