/// @param Entity
/// @param [from-lists?]

var entity = argument[0];
var from_lists = (argument_count > 1) ? argument[1] : false;
var map = Stuff.active_map.contents;

if (from_lists && entity.listed) {
    if (entity.batchable) {
        if (entity.batch_index == -1) {
            var future = map.batch_in_the_future;
            ds_list_delete(future, ds_list_find_index(future, entity));
        } else {
            var bl = map.batch_instances[| entity.batch_index];
            ds_list_delete(bl, ds_list_find_index(bl, entity));
            batch_again(entity.batch_index);
        }
    } else {
        ds_list_delete(map.dynamic, ds_list_find_index(map.dynamic, entity));
    }
    
    ds_list_delete(map.all_entities, ds_list_find_index(map.all_entities, entity));
}

var cell = map_get_grid_cell(entity.xx, entity.yy, entity.zz);
if (cell[@ entity.slot] == entity) {
    cell[@ entity.slot] = noone;
}