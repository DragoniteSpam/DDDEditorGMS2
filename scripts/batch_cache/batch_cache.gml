function batch_cache() {
    var map_contents = Stuff.map.active_map.contents;
    
    var batch = {
        instances: ds_list_create(),
        vertex: vertex_create_buffer(),
        reflect_vertex: vertex_create_buffer(),
    };
    
    array_push(map_contents.batches, batch);
    vertex_begin(batch.vertex, Stuff.graphics.format);
    vertex_begin(batch.reflect_vertex, Stuff.graphics.format);
    
    for (var i = 0; i < ds_list_size(map_contents.batch_in_the_future); i++) {
        var thing = map_contents.batch_in_the_future[| i];
        thing.batch_addr = map_contents.batches[array_length(map_contents.batches) - 1];
        thing.batch(batch.vertex, batch.reflect_vertex, thing);
        ds_list_add(batch.instances, thing);
    }
    
    vertex_end(batch.vertex);
    vertex_freeze(batch.vertex);
    vertex_end(batch.reflect_vertex);
    if (vertex_get_number(batch.reflect_vertex) > 0) {
        vertex_freeze(batch.reflect_vertex);
    }
    
    ds_list_clear(map_contents.batch_in_the_future);
}