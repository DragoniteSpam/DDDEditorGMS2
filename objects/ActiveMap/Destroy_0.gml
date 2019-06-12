event_inherited();

for (var i = 0; i < ds_list_size(batches); i++) {
    vertex_delete_buffer(batches[| i]);
    vertex_delete_buffer(batches_wire[| i]);
}

ds_list_destroy(batches);
ds_list_destroy(batches_wire);

// don't actually delete the instances from here or bad things will happen
ds_list_destroy(batch_instances);
ds_list_destroy(batch_in_the_future);
ds_list_destroy(dynamic);

// the last three lists are not guaranteed to have all
// entities in the map in them. this one is.
ds_list_destroy_instances/*_scheduled*/(all_entities);

ds_grid_destroy(map_grid);

vertex_delete_buffer(frozen);

ds_list_destroy(audio_ambient);
ds_list_destroy(audio_ambient_frequencies);