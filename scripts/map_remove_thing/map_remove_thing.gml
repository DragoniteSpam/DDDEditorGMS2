/// @description void map_remove_thing(Entity);
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
if (argument0.listed) {
    if (argument0.batchable) {
        if (argument0.batch_index==-1) {
            var future=ActiveMap.batch_in_the_future;
            ds_list_delete(future, ds_list_find_index(future, argument0));
        } else {
            var bl=ActiveMap.batch_instances[| argument0.batch_index];
            ds_list_delete(bl, ds_list_find_index(bl, argument0));
            batch_again(argument0.batch_index);
        }
    } else {
        ds_list_delete(ActiveMap.dynamic, ds_list_find_index(ActiveMap.dynamic, argument0));
    }
    
    ds_list_delete(ActiveMap.all_entities, ds_list_find_index(ActiveMap.all_entities, argument0));
}

var cell=map_get_grid_cell(argument0.xx, argument0.yy, argument0.zz);
if (cell[@ argument0.slot]==argument0) {
    cell[@ argument0.slot]=noone;
}
