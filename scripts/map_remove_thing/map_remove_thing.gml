/// @param Entity

// this is INSANELY slow for large numbers of entities, and I'm
// actually not sure how long it would take to carry out if you
// did something like select all+delete. long enough that most
// people would get frusturated and restart the program.

// this is thanks to the ds_list_find_index and NEEDS to be
// worked on. a starting point would be to assign each instance
// a variable storing the location in the future list or batch
// instance list. however, that will also be slow due to the
// need to update the stored index of each other entity in the
// lists: it would probably be better to zero out the indices
// instead of deleteting them first, and then at the end make a
// second pass over each of the lists, removing the zeroes and
// updating the variables storing the indices for the entities.

// this NEEDS to be worked on sooner rather than later because i
// imagine Delete All is going to be a somewhat common operation.

var entity = argument0;
var map = Stuff.active_map.contents;

if (entity.listed) {
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