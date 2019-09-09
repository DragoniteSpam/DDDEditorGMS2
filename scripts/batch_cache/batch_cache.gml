var map = Stuff.active_map;

var buffer = vertex_create_buffer();
var buffer_wire = vertex_create_buffer();
vertex_begin(buffer, Camera.vertex_format);
vertex_begin(buffer_wire, Camera.vertex_format);
var list = ds_list_create();

for (var i = 0; i < ds_list_size(map.batch_in_the_future); i++) {
    var thing = map.batch_in_the_future[| i];
    thing.batch_index = ds_list_size(map.batches);
    // see comments on the buffer in batch_again
    var results = script_execute(thing.batch, buffer, buffer_wire, thing);
    buffer = results[0];
    buffer_wire = results[1];
    
    ds_list_add(list, thing);
}

vertex_end(buffer);
vertex_freeze(buffer);

vertex_end(buffer_wire);
vertex_freeze(buffer_wire);

ds_list_add(map.batches, buffer);
ds_list_add(map.batches_wire, buffer_wire);
ds_list_add(map.batch_instances, list);

ds_list_clear(map.batch_in_the_future);