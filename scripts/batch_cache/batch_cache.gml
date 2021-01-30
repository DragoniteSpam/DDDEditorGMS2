function batch_cache() {
    var map_contents = Stuff.map.active_map.contents;
    
    var buffer = vertex_create_buffer();
    var buffer_wire = vertex_create_buffer();
    var reflect_buffer = vertex_create_buffer();
    var reflect_buffer_wire = vertex_create_buffer();
    vertex_begin(buffer, Stuff.graphics.vertex_format);
    vertex_begin(buffer_wire, Stuff.graphics.vertex_format);
    
    var batch = {
        instances: ds_list_create(),
        vertex: buffer,
        wire: buffer_wire,
        reflect_vertex: reflect_buffer,
        reflect_wire: reflect_buffer_wire,
    };
    array_push(map_contents.batches, batch);
    
    for (var i = 0; i < ds_list_size(map_contents.batch_in_the_future); i++) {
        var thing = map_contents.batch_in_the_future[| i];
        thing.batch_addr = map_contents.batches[array_length(map_contents.batches) - 1];
        thing.batch(buffer, buffer_wire, thing);
        
        ds_list_add(batch.instances, thing);
    }
    
    vertex_end(buffer);
    vertex_freeze(buffer);
    vertex_end(buffer_wire);
    vertex_freeze(buffer_wire);
    
    ds_list_clear(map_contents.batch_in_the_future);
}