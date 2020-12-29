function batch_again(index) {
    var map = Stuff.map.active_map.contents;
    
    // If no index is provided it just rebatches EVERYTHING. This is very slow.
    // Please don't use it constantly otherwise the program will become very
    // unenjoyable to use.
    if (index == undefined) {
        for (var i = 0; i < ds_list_size(map.batch_data); i++) {
            batch_again(i);
        }
        return;
    }
    
    if (index == -1) return;
    
    var data = map.batch_data[| index];
    vertex_delete_buffer(data.vertex);
    vertex_delete_buffer(data.wire);
    var list_instances = data.instances;
    
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
        
        data.vertex = buffer;
        data.wire = buffer_wire;
    } else {
        // empty batch lists should be deleted, for obvious reasons
        ds_list_destroy(list_instances);
        ds_map_destroy(data);
        ds_list_delete(map.batch_data, ds_list_find_index(map.batch_data, data));
    }
}