if (Stuff.is_quitting) exit;

event_inherited();

for (var i = 0; i < array_length(batches); i++) {
    var data = batches[i];
    if (data.vertex) vertex_delete_buffer(data.vertex);
    if (data.wire) vertex_delete_buffer(data.wire);
    if (data.reflect_vertex) vertex_delete_buffer(data.reflect_vertex);
    if (data.reflect_wire) vertex_delete_buffer(data.reflect_wire);
}

// don't actually delete the instances from here or bad things will happen
ds_list_destroy(batch_in_the_future);
ds_list_destroy(dynamic);

// the last three lists are not guaranteed to have all
// entities in the map in them. this one is.
ds_list_destroy_instances(all_entities);
ds_list_destroy_instances(all_zones);

if (frozen) vertex_delete_buffer(frozen);
if (frozen_wire) vertex_delete_buffer(frozen_wire);
if (reflect_frozen) vertex_delete_buffer(reflect_frozen);
if (reflect_frozen_wire) vertex_delete_buffer(reflect_frozen_wire);
if (frozen_data) buffer_delete(frozen_data);
if (frozen_data_wire) buffer_delete(frozen_data_wire);
if (reflect_frozen_data) buffer_delete(reflect_frozen_data);
if (reflect_frozen_data_wire) buffer_delete(reflect_frozen_data_wire);