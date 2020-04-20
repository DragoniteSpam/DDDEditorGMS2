if (Stuff.is_quitting) exit;

event_inherited();
var t0 = get_timer() / 1000;
for (var i = 0; i < ds_list_size(batch_data); i++) {
    var data = batch_data[| i];
    vertex_delete_buffer(data[? "vertex"]);
    vertex_delete_buffer(data[? "wire"]);
}

// this is a json, so all of the sub-objects and stuff will be taken care
// of automatically, as well
ds_list_destroy(batch_data);

// don't actually delete the instances from here or bad things will happen
ds_list_destroy(batch_in_the_future);
ds_list_destroy(dynamic);

// the last three lists are not guaranteed to have all
// entities in the map in them. this one is.
ds_list_destroy_instances(all_entities);
ds_list_destroy_instances(all_zones);
ds_map_destroy(refids);

ds_grid_destroy(map_grid);

if (frozen) vertex_delete_buffer(frozen);
if (frozen_wire) vertex_delete_buffer(frozen_wire);
buffer_delete(frozen_data);
buffer_delete(frozen_data_wire);

for (var i = 0; i < array_length_1d(mesh_autotiles_top_raw); i++) {
    if (mesh_autotiles_top_raw[i]) {
        buffer_delete(mesh_autotiles_top_raw[i]);
        vertex_delete_buffer(mesh_autotiles_top[i]);
    }
}