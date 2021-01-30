function batch_cache() {
    var map_contents = Stuff.map.active_map.contents;
    
    var batch = {
        instances: ds_list_create(),
        vertex: vertex_create_buffer(),
        wire: vertex_create_buffer(),
        reflect_vertex: vertex_create_buffer(),
        reflect_wire: vertex_create_buffer(),
    };
    
    array_push(map_contents.batches, batch);
    vertex_begin(batch.vertex, Stuff.graphics.vertex_format);
    vertex_begin(batch.wire, Stuff.graphics.vertex_format);
    vertex_begin(batch.reflect_vertex, Stuff.graphics.vertex_format);
    vertex_begin(batch.reflect_wire, Stuff.graphics.vertex_format);
    
    for (var i = 0; i < ds_list_size(map_contents.batch_in_the_future); i++) {
        var thing = map_contents.batch_in_the_future[| i];
        thing.batch_addr = map_contents.batches[array_length(map_contents.batches) - 1];
        thing.batch(batch.vertex, batch.wire, thing);
        ds_list_add(batch.instances, thing);
    }
    
    vertex_end(batch.vertex);
    vertex_freeze(batch.vertex);
    vertex_end(batch.wire);
    vertex_freeze(batch.wire);
    vertex_end(batch.reflect_vertex);
    vertex_freeze(batch.reflect_vertex);
    vertex_end(batch.reflect_wire);
    vertex_freeze(batch.reflect_wire);
    
    ds_list_clear(map_contents.batch_in_the_future);
}