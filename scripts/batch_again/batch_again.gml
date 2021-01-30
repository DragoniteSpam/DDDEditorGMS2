function batch_again(batch) {
    var map = Stuff.map.active_map.contents;
    
    // If no index is provided it just rebatches EVERYTHING. This is very slow.
    // Please don't use it constantly otherwise the program will become very
    // unenjoyable to use.
    if (!batch) {
        for (var i = 0; i < array_length(map.batches); i++) {
            batch_again(map.batches[i]);
        }
        return;
    }
    
    vertex_delete_buffer(batch.vertex);
    vertex_delete_buffer(batch.wire);
    vertex_delete_buffer(batch.reflect_vertex);
    vertex_delete_buffer(batch.reflect_wire);
    var list_instances = batch.instances;
    
    if (ds_list_size(list_instances) > 0) {
        batch.vertex = vertex_create_buffer();
        batch.wire = vertex_create_buffer();
        batch.reflect_vertex = vertex_create_buffer();
        batch.reflect_wire = vertex_create_buffer();
        vertex_begin(batch.vertex, Stuff.graphics.vertex_format);
        vertex_begin(batch.wire, Stuff.graphics.vertex_format);
        vertex_begin(batch.reflect_vertex, Stuff.graphics.vertex_format);
        vertex_begin(batch.reflect_wire, Stuff.graphics.vertex_format);
        
        for (var i = 0; i < ds_list_size(list_instances); i++) {
            list_instances[| i].batch(batch.vertex, batch.wire, batch.reflect_vertex, batch.reflect_wire, list_instances[| i]);
        }
        
        vertex_end(batch.vertex);
        vertex_freeze(batch.vertex);
        vertex_end(batch.wire);
        vertex_freeze(batch.wire);
        vertex_end(batch.reflect_vertex);
        vertex_freeze(batch.reflect_vertex);
        vertex_end(batch.reflect_wire);
        vertex_freeze(batch.reflect_wire);
    } else {
        // empty batch lists should be deleted, for obvious reasons
        ds_list_destroy(list_instances);
        array_delete(map.batches, array_search(map.batches, batch), 1);
    }
}