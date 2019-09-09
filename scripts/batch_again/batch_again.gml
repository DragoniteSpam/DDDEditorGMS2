/// @param index

var index = argument0;
var map = Stuff.active_map;

vertex_delete_buffer(map.batches[| index]);
vertex_delete_buffer(map.batches_wire[| index]);
var list = map.batch_instances[| index];

if (ds_list_size(list) > 0) {
    var buffer = vertex_create_buffer();
    var buffer_wire = vertex_create_buffer();
    vertex_begin(buffer, Camera.vertex_format);
    vertex_begin(buffer_wire, Camera.vertex_format);
    
    for (var i = 0; i < ds_list_size(list); i++) {
        // in case the buffer gets recreated, you need to return it in every
        // iteration of the loop
        var results = script_execute(list[| i].batch, buffer, buffer_wire, list[| i]);
        buffer = results[0];
        buffer_wire = results[1];
    }
    
    vertex_end(buffer);
    vertex_freeze(buffer);
    
    vertex_end(buffer_wire);
    vertex_freeze(buffer_wire);
    
    map.batches[| index] = buffer;
    map.batches_wire[| index] = buffer_wire;
} else {
    ds_list_destroy(list);
    ds_list_delete(map.batches, index);
    ds_list_delete(map.batches_wire, index);
    ds_list_delete(map.batch_instances, index);
    
    for (var i = 0; i < ds_list_size(map.all_entities); i++) {
        var thing = map.all_entities[| i];
        if (thing.batch_index > index) {
            thing.batch_index--;
        }
    }
}