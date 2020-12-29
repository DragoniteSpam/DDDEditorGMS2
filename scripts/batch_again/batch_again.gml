function batch_again(batch) {
    var map = Stuff.map.active_map.contents;
    
    // If no index is provided it just rebatches EVERYTHING. This is very slow.
    // Please don't use it constantly otherwise the program will become very
    // unenjoyable to use.
    if (!batch) {
        for (var i = 0; i < ds_list_size(map.batches); i++) {
            batch_again(map.batches[i]);
        }
        return;
    }
    
    vertex_delete_buffer(batch.vertex);
    vertex_delete_buffer(batch.wire);
    var list_instances = batch.instances;
    
    if (ds_list_size(list_instances) > 0) {
        var buffer = vertex_create_buffer();
        var buffer_wire = vertex_create_buffer();
        vertex_begin(buffer, Stuff.graphics.vertex_format);
        vertex_begin(buffer_wire, Stuff.graphics.vertex_format);
        
        for (var i = 0; i < ds_list_size(list_instances); i++) {
            // in case the buffer gets recreated, you need to return it in every
            // iteration of the loop
            var results = list_instances[| i].batch(buffer, buffer_wire, list_instances[| i]);
            buffer = results[0];
            buffer_wire = results[1];
        }
        
        vertex_end(buffer);
        vertex_freeze(buffer);
        
        vertex_end(buffer_wire);
        vertex_freeze(buffer_wire);
        
        batch.vertex = buffer;
        batch.wire = buffer_wire;
    } else {
        // empty batch lists should be deleted, for obvious reasons
        ds_list_destroy(list_instances);
        array_delete(map.batches, array_search(map.batches, batch), 1);
    }
}